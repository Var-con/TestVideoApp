//
//  ViewController.swift
//  TestVideoApp
//
//  Created by Станислав Климов on 24.09.2020.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let cacheManager = CacheManager()
    private var videosUrls: [URL] = []
    @IBOutlet var waitingLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchUrlsOfVideos()
    }
    
    private func fetchUrlsOfVideos() {
        networkManager.fetchVideoData(from: URLlist.forThisApp.rawValue) { [weak self] result in
            switch result {
            case .failure(let error ) :
                DispatchQueue.main.async {
                    self!.stopIndication()
                    self!.showAlert(error)
                }
            case .success(let urls) :
                self!.cachingVideo(with: urls)
            }
        }
    }
    
    private func cachingVideo(with videoUrls: [String]) {
        for url in videoUrls {
            cacheManager.getFileWith(stringUrl: url) { (result) in
                switch result {
                case .success(let url) :
                    self.videosUrls.append(url)
                case .failure(let error) :
                    self.showAlert(error)
                }
            }
        }
        DispatchQueue.main.async { [self] in
            stopIndication()
            setupVideoPlayer()
        }
    }
    
    func stopIndication() {
        DispatchQueue.main.async { [self] in
            activityIndicator.stopAnimating()
            waitingLabel.isHidden = true
        }
    }
    
    private func setupVideoPlayer() {
        let videoLooper = VideoLooperView(videos: videosUrls)
        view.addSubview(videoLooper)
        videoLooper.backgroundColor = .black
        videoLooper.translatesAutoresizingMaskIntoConstraints = false
        videoLooper.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1).isActive = true
        videoLooper.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 1).isActive = true
        videoLooper.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1).isActive = true
        videoLooper.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 1).isActive = true
        
        videoLooper.play()
        
    }
}

extension ViewController {
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Download error!",
                                      message: "Error in the network service. \(error.localizedDescription)",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
