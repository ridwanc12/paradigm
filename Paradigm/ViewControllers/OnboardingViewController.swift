//
//  OnboardingViewController.swift
//  Paradigm
//
//  Created by Isha Mahadalkar on 4/23/21.
//  Copyright © 2021 team5. All rights reserved.
//

import UIKit
import Lottie

struct Slide {
    let title: String
    let animationName: String
    let buttonTitle: String

    static let collection: [Slide] = [
        .init(title: "Insert mini journals everyday so you can keep track of your mental health.", animationName: "lottieJournal", buttonTitle: "Next"),
        .init(title: "We'll analyse the journals for you and give you a daily as well as long term statistics.", animationName: "lottieAnalysis", buttonTitle: "Next"),
        .init(title: "Keep a virtual journal where you can see a list of your entries which you can add, edit and share.", animationName: "lottieList", buttonTitle: "Get Started")
    ]
}

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let slides: [Slide] = Slide.collection
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
    }
    
    private func handleActionButtonTapped(at indexPath: IndexPath) {
        if indexPath.item == slides.count - 1 {
            // We are on the last slide
            showMainApp()
        }
        else {
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
        }
    }
    
    private func showMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyboard.instantiateViewController(identifier: "LoginViewController")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            window.rootViewController = loginView
            
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: nil, completion: nil)
        }
    }

}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! OnboardingCollectionViewCell
        let slide = slides[indexPath.item]
        cell.configure(with: slide)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var actionButtonDidTap: (() -> Void)?
    
    @IBAction func actionButtonTapped() {
        actionButtonDidTap?()
    }
    
    func configure(with slide: Slide) {
        titleLabel.text = slide.title
        actionButton.setTitle(slide.buttonTitle, for: .normal)

        let animation = Animation.named(slide.animationName)
        animationView.animation = animation
        animationView.loopMode = .loop

        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}
