//
//  DetailViewController.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/18.
//

import UIKit

final class DetailViewController: UIViewController {

    private lazy var detailView: DetailView = {
        let detailView = DetailView(viewController: self, data: self.toDoData)
        return detailView
    }()
    
    private lazy var deleteBarButton: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        item.tintColor = .red
        return item
    }()
    
    @objc func didTapDeleteButton() {
        alert()
    }
        
    private let toDoData: ToDoData?
    
    init(data: ToDoData?) {
        self.toDoData = data
        super.init(nibName: nil, bundle: nil)
        if data != nil {
            navigationItem.title = "메모 수정하기"
            navigationItem.rightBarButtonItem = deleteBarButton
        } else {
            navigationItem.title = "새로운 메모 생성하기"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
}

private extension DetailViewController {
    func attribute() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func alert() {
        let alertController = UIAlertController(title: "알림", message: "정말 삭제하시겠습니까 ?", preferredStyle: .alert)
        [
            UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                CoreDataManager.shared.deleteToDo(data: self.toDoData!)
                self.navigationController?.popViewController(animated: true)
            }),
            UIAlertAction(title: "취소", style: .cancel)
        ].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true)
    }
}



// MARK: - func
extension DetailViewController: DetailViewDelegate {
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

