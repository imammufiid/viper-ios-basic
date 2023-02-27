//
//  NoticeVC.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import UIKit

class NoticeVC: UIViewController {
    var presenter: ViewToPresenterProtocol?

    @IBOutlet weak var tableView: UITableView!
    var notices: [NoticeModel] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notice-Module"
        presenter?.startFetchingNotice()
        showProgressIndicator(view: view)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NoticeVC: PresenterToViewProtocol {
    func showNotice(notices: [NoticeModel]) {
        self.notices = notices
        tableView.reloadData()
        hideProgressIndicator(view: view)
    }

    func showNoticeError(message: String) {
        hideProgressIndicator(view: view)
        let alert = UIAlertController(title: "Terjadi Kesalahan", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) { _ in
            self.presenter?.showMovieController(message)
        })
        present(alert, animated: true, completion: nil)
    }
}

extension NoticeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoticeCell
        cell.id.text = notices[indexPath.row].id
        cell.title.text = notices[indexPath.row].title
        cell.brief.text = notices[indexPath.row].brief
        cell.file_source.text = notices[indexPath.row].fileSource
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showMovieController("On Click")
    }
}

class NoticeCell: UITableViewCell {
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var brief: UILabel!
    @IBOutlet weak var file_source: UILabel!
}
