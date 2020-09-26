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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var waitingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        fetchUrlsOfVideos()
    }
    
    private func fetchUrlsOfVideos() {
        networkManager.fetchVideoData(from: URLlist.forThisApp.rawValue) { massive in
            self.cachingVideo(with: massive)
        }
    }
    
    private func cachingVideo(with videoUrls: [String]) {
        for url in videoUrls {
            cacheManager.getFileWith(stringUrl: url) { (result) in
                switch result {
                case .success(let url) :
                    self.videosUrls.append(url)
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
        DispatchQueue.main.async {
            self.endDownloading()
            self.setupVideoPlayer()
        }
    }
    
    private func setupVideoPlayer() {
        let videoLooper = VideoLooperView(videos: videosUrls)
        view.addSubview(videoLooper)
        videoLooper.backgroundColor = .black
        videoLooper.translatesAutoresizingMaskIntoConstraints = false
        videoLooper.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        videoLooper.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        videoLooper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        videoLooper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        videoLooper.play()
    }
    
    private func endDownloading() {
        activityIndicator.stopAnimating()
        waitingLabel.isHidden = true
    }
}

