//
//  DetailView.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/18.
//

import UIKit

protocol DetailViewDelegate {
    func popViewController()
}

final class DetailView: UIView {

    private var temporaaryNum: Int64
    private let viewController: DetailViewDelegate
    private let toDoData: ToDoData?
    
    init(viewController: DetailViewDelegate, data: ToDoData?) {
        self.viewController = viewController
        self.toDoData = data
        self.temporaaryNum = toDoData?.color ?? 1
        super.init(frame: .zero)
        self.backgroundColor = .white
        layout()
        configureUI()
    }
    

    private  lazy var buttons: [UIButton] = {
        return [redButton, greenButton, blueButton, purpleButton]
    }()
    
    private lazy var redButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.setTitle("Red", for: .normal)
        button.setTitleColor(MyColor.red.buttonColor, for: .normal)
        button.backgroundColor = MyColor.red.backgoundColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var greenButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 2
        button.setTitle("Green", for: .normal)
        button.setTitleColor(MyColor.green.buttonColor, for: .normal)
        button.backgroundColor = MyColor.green.backgoundColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 3
        button.setTitle("Blue", for: .normal)
        button.setTitleColor(MyColor.blue.buttonColor, for: .normal)
        button.backgroundColor = MyColor.blue.backgoundColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var purpleButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 4
        button.setTitle("Purple", for: .normal)
        button.setTitleColor(MyColor.purple.buttonColor, for: .normal)
        button.backgroundColor = MyColor.purple.backgoundColor
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorButtonSV: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.text = "텍스트를 여기에 입력하세요."
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    private lazy var mainTextViewBackgroundView: UIView = {
        let view = UIView()
        view.addSubview(mainTextView)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
   

    override func layoutSubviews() {
        super.layoutSubviews()
        buttons.forEach { button in
            button.clipsToBounds = true
            button.layer.cornerRadius = colorButtonSV.bounds.height / 2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - func
private extension DetailView {
    @objc func saveButtonTapped(_ sender: UIButton) {
        // 기존 데이터가 있을 때 -> 기존 데이터 업데이트
        if let toDoData = self.toDoData {
            toDoData.memoText = mainTextView.text
            toDoData.color = temporaaryNum
            CoreDataManager.shared.updateToDo(newToDoData: toDoData)
        // 기존 데이터가 없을 때 -> 새로운 데이터 생성
        } else {
            let memoText = mainTextView.text
            CoreDataManager.shared.saveToDoData(toDoText: memoText, colorInt: temporaaryNum)
        }
        viewController.popViewController()
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        let num = Int64(sender.tag)
        self.temporaaryNum = num
        
        let color = MyColor(rawValue: num)
        setupColorTheme(color: color)
        
        clearButtonColors()
        setupColorButton(num: num)
    }
    
}


// MARK: - layout
private extension DetailView {
    
    func configureUI() {
        // 기존 데이터가 있을 때
        if let  toDoData = self.toDoData {
            guard let text = toDoData.memoText else { return }
            mainTextView.text = text
            mainTextView.textColor = .black
            saveButton.setTitle("UPDATE", for: .normal)
            mainTextView.becomeFirstResponder()
            let color = MyColor(rawValue: toDoData.color)
            setupColorTheme(color: color)
        
        // 기존 데이터가 없을 때
        } else {
            mainTextView.text = "텍스트를 여기에 입력하세요."
            mainTextView.textColor = .lightGray
            setupColorTheme()
        }
        setupColorButton(num: temporaaryNum)
    }
    
    
    func layout() {
        [colorButtonSV, mainTextViewBackgroundView, saveButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            colorButtonSV.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            colorButtonSV.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            colorButtonSV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            colorButtonSV.heightAnchor.constraint(equalToConstant: 35),
            
            mainTextViewBackgroundView.topAnchor.constraint(equalTo: self.colorButtonSV.bottomAnchor, constant: 40),
            mainTextViewBackgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            mainTextViewBackgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            mainTextViewBackgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            mainTextView.leadingAnchor.constraint(equalTo: self.mainTextViewBackgroundView.leadingAnchor, constant: 15),
            mainTextView.trailingAnchor.constraint(equalTo: self.mainTextViewBackgroundView.trailingAnchor, constant: -15),
            mainTextView.topAnchor.constraint(equalTo: self.mainTextViewBackgroundView.topAnchor, constant: 8),
            mainTextView.bottomAnchor.constraint(equalTo: self.mainTextViewBackgroundView.bottomAnchor, constant: -8),
            
            saveButton.topAnchor.constraint(equalTo: self.mainTextViewBackgroundView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            saveButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupColorTheme(color: MyColor? = .red) {
        mainTextViewBackgroundView.backgroundColor = color?.backgoundColor
        saveButton.backgroundColor = color?.buttonColor
    }
    
    func setupColorButton(num: Int64) {
        switch num {
        case 1:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.white, for: .normal)
        case 2:
            greenButton.backgroundColor = MyColor.green.buttonColor
            greenButton.setTitleColor(.white, for: .normal)
        case 3:
            blueButton.backgroundColor = MyColor.blue.buttonColor
            blueButton.setTitleColor(.white, for: .normal)
        case 4:
            purpleButton.backgroundColor = MyColor.purple.buttonColor
            purpleButton.setTitleColor(.white, for: .normal)
        default:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func clearButtonColors() {
        redButton.backgroundColor = MyColor.red.backgoundColor
        redButton.setTitleColor(MyColor.red.buttonColor, for: .normal)
        greenButton.backgroundColor = MyColor.green.backgoundColor
        greenButton.setTitleColor(MyColor.green.buttonColor, for: .normal)
        blueButton.backgroundColor = MyColor.blue.backgoundColor
        blueButton.setTitleColor(MyColor.blue.buttonColor, for: .normal)
        purpleButton.backgroundColor = MyColor.purple.backgoundColor
        purpleButton.setTitleColor(MyColor.purple.buttonColor, for: .normal)
    }
}

// MARK: - UITextViewDelegate
extension DetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "텍스트를 여기에 입력하세요."
            textView.textColor = .lightGray
        }
    }
}
