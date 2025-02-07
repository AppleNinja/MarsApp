//
//  GalleryViewController.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private let viewModel: GalleryViewModel
    
    private let collectionView: UICollectionView
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        self.title = "MarsRobots"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.register(ImageCardCell.self, forCellWithReuseIdentifier: ImageCardCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        observeViewModel()
        
        viewModel.loadMarsImages()
    }
    
    private func observeViewModel() {
        viewModel.onLoadingStatusChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView.reloadData()
                }
            }
        }
        
        viewModel.onErrorMessageChanged = { [weak self] errorMsg in
            guard let self = self, let message = errorMsg, !message.isEmpty else { return }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error",
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCardCell.reuseId,
            for: indexPath
        )
        if let cardCell = cell as? ImageCardCell {
            let marsImage = viewModel.images[indexPath.item]
            cardCell.configure(with: marsImage)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalHorizontalSpacing: CGFloat = 16 + 16 + 16
        let usableWidth = collectionView.bounds.width - totalHorizontalSpacing
        let widthPerItem = floor(usableWidth / 2)
        let height: CGFloat = 300
        return CGSize(width: widthPerItem, height: height)
    }
}
