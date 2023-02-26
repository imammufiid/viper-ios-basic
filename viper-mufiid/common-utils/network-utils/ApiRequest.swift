//
//  ApiRequest.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Alamofire
import Foundation

class APIRequest<T: Decodable>: NSObject {
    func execute(url: String,
                 method: Alamofire.HTTPMethod,
                 parameters: Parameters,
                 encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                 success: @escaping (_ response: T) -> Void,
                 failure: @escaping (_ error: String) -> Void)
    {
        if !NetworkReachabilityManager()!.isReachable {
            failure(NO_INTERNET_MSG)
            return
        }
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        var headers: Alamofire.HTTPHeaders = [:]
        headers["Authorization"] = "Bearer 000"
        headers["Version-Name"] = appVersion
        headers["Version-Code"] = build
        
        let dataRequest: DataRequest = AF.request(url,
                                                  method: method,
                                                  parameters: parameters,
                                                  encoding: encoding,
                                                  headers: headers).debugLog()
        
        dataRequest.responseString { response in
            if response.response?.statusCode == 401 {
                self.logout()
                return
            }
            
            switch response.result {
            case .success:
                do {
                    let apiResponse = try JSONDecoder().decode(T.self, from: response.data!)
                    let defaultResponse = try JSONDecoder().decode(DefaultResponse.self, from: response.data!)
                    DispatchQueue.main.async {
                        if defaultResponse.success == 0 {
                            if defaultResponse.error_code == "UNAUTHORIZED_USER" {
                                self.logout()
                            } else {
                                let message: String = (defaultResponse.message == "" ? defaultResponse.error_code : defaultResponse.message) ?? NO_INTERNET_MSG
                                failure(message)
                            }
                        } else {
                            success(apiResponse)
                        }
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        failure(NO_INTERNET_MSG)
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    failure(NO_INTERNET_MSG)
                }
            }
        }
    }
    
    func executeAsyncParse(url: String,
                           method: Alamofire.HTTPMethod,
                           parameters: Parameters,
                           encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                           success: @escaping (_ response: T) -> Void,
                           failure: @escaping (_ error: String) -> Void)
    {
        if !NetworkReachabilityManager()!.isReachable {
            failure(NO_INTERNET_MSG)
            return
        }
        
        var headers: Alamofire.HTTPHeaders = [:]
        headers["Authorization"] = "Bearer 000"
        
        let dataRequest: DataRequest = AF.request(url,
                                                  method: method,
                                                  parameters: parameters,
                                                  encoding: encoding,
                                                  headers: headers).debugLog()
        
        dataRequest.responseString { response in
            DispatchQueue.global(qos: .background).async {
                if response.response?.statusCode == 401 {
                    self.logout()
                    return
                }
                
                switch response.result {
                case .success:
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: response.data!)
                        let defaultResponse = try JSONDecoder().decode(DefaultResponse.self, from: response.data!)
                        
                        DispatchQueue.main.async {
                            if defaultResponse.success == 0 {
                                if defaultResponse.error_code == "AUTH01-E006" { // resend otp still waiting
                                    success(apiResponse)
                                    return
                                }
                                if defaultResponse.error_code == "UNAUTHORIZED_USER" {
                                    self.logout()
                                } else {
                                    let message: String = (defaultResponse.message == "" ? defaultResponse.error_code : defaultResponse.message) ?? NO_INTERNET_MSG
                                    failure(message)
                                }
                            } else {
                                success(apiResponse)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print(error)
                            failure(NO_INTERNET_MSG)
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        failure(NO_INTERNET_MSG)
                    }
                }
            }
        }
    }
    
    func upload(requestURL: String,
                requestMethod: Alamofire.HTTPMethod,
                requestHeaders: Alamofire.HTTPHeaders,
                parameters: [String: String],
                files: [File],
                success: @escaping (_ response: T) -> Void,
                failure: @escaping (_ error: String) -> Void)
    {
        var headers: Alamofire.HTTPHeaders = [:]
        headers = requestHeaders
        headers["Authorization"] = "Bearer 000"
        
        AF.upload(multipartFormData: { multipartFormData in
            for file in files {
                multipartFormData.append(file.data, withName: file.key, fileName: file.name, mimeType: file.mime)
                print("param photo : \(file.key ?? "")")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: requestURL,
        method: requestMethod,
        headers: headers).responseData { response in
            if response.response?.statusCode == 401 {
                self.logout()
                return
            }
            if let err = response.error {
                failure(err.localizedDescription)
                return
            }
            print(String(data: response.data!, encoding: String.Encoding.utf8) ?? "upload success")
            do {
                let apiResponse = try JSONDecoder().decode(T.self, from: response.data!)
                let defaultResponse = try JSONDecoder().decode(DefaultResponse.self, from: response.data!)
                DispatchQueue.main.async {
                    if defaultResponse.success == 0 {
                        if defaultResponse.error_code == "UNAUTHORIZED_USER" {
                            self.logout()
                        } else {
                            failure(defaultResponse.message ?? "Something went wrong")
                        }
                    } else {
                        success(apiResponse)
                    }
                }
            } catch {
                print(error)
                failure(error.localizedDescription)
            }
        }
    }
    
    func upload(requestURL: String,
                requestMethod: Alamofire.HTTPMethod,
                requestHeaders: Alamofire.HTTPHeaders,
                parameters: Parameters,
                files: [String: File?],
                arrayParams: [String: [Any]],
                arrayObjectParams: [String: [String]] = [:],
                success: @escaping (_ response: T) -> Void,
                failure: @escaping (_ error: String) -> Void)
    {
        var headers: Alamofire.HTTPHeaders = [:]
        headers = requestHeaders
        headers["Authorization"] = "Bearer 000"
        
        AF.upload(multipartFormData: { multipartFormData in
            /// Append for files params
            for (key, file) in files {
                if file != nil {
                    multipartFormData.append(file!.data, withName: file!.key, fileName: file!.name, mimeType: file!.mime)
                    print("--------> PARAM_FILE => \(file!.key ?? "")")
                } else {
                    print("--------> PARAM_FILE_NULL => \(key)")
                    multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: key, fileName: nil, mimeType: "text/plain")
                }
            }
            
            /// Append for params
            for (key, value) in parameters {
                let data = "\(value)"
                multipartFormData.append(data.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            /// Append for array params
            for (key, value) in arrayParams {
                for i in 0 ..< value.count {
                    let nvalue = value[i] as! Int
                    let valueObj = String(nvalue)
                    let keyObj = key + "[" + String(i) + "]"
                    print("--------> PARAM_ARRAY => \(keyObj) -> \(valueObj)")
                    multipartFormData.append(valueObj.data(using: String.Encoding.utf8)!, withName: keyObj)
                }
            }
            
            /// Append for list of object params
            /// in this case object params already mapped to jsonEncoded
            if arrayObjectParams.isEmpty == false {
                for (key, value) in arrayObjectParams {
                    for i in 0 ..< value.count {
                        let nvalue = value[i]
                        let valueObj = nvalue
                        let keyObj = key + "[" + String(i) + "]"
                        print("--------ARRAY_OBJ => \(keyObj) -> \(valueObj)")
                        multipartFormData.append(valueObj.data(using: String.Encoding.utf8)!, withName: keyObj)
                    }
                }
            }
        }, to: requestURL,
        method: requestMethod,
        headers: headers).responseData { response in
            if response.response?.statusCode == 401 {
                self.logout()
                return
            }
            if let err = response.error {
                failure(err.localizedDescription)
                return
            }
            print(String(data: response.data!, encoding: String.Encoding.utf8) ?? "upload success")
            do {
                let apiResponse = try JSONDecoder().decode(T.self, from: response.data!)
                let defaultResponse = try JSONDecoder().decode(DefaultResponse.self, from: response.data!)
                DispatchQueue.main.async {
                    if defaultResponse.success == 0 {
                        if defaultResponse.error_code == "UNAUTHORIZED_USER" {
                            self.logout()
                        } else {
                            failure(defaultResponse.message ?? "Something went wrong")
                        }
                    } else {
                        success(apiResponse)
                    }
                }
            } catch {
                print(error)
                failure(error.localizedDescription)
            }
        }
    }
    
    private func logout() {
        DispatchQueue.main.async {
            // UserDefaultStore.token = ""
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginNavigation")
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}

public extension Request {
    func debugLog() -> Self {
        debugPrint(self)
        return self
    }
}

struct File {
    var data: Data!
    var mime: String!
    var name: String!
    var key: String!
    
    init(data: Data, mime: String, name: String, key: String) {
        self.data = data
        self.mime = mime
        self.name = name
        self.key = key
    }
}
