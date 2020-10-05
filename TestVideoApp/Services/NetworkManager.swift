//
//  NetworkManager.swift
//  TestVideoApp
//
//  Created by Станислав Климов on 24.09.2020.
//

import Foundation

class NetworkManager {
    
    func fetchVideoData(from url: String, compitionHandler: @escaping (_ exist: Result<[String]>) -> Void){
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                compitionHandler(Result.failure(error as NSError))
            } else {
                if let data = data {
                    self.receveingVideoStrings(with: data) { result in
                        switch result {
                        case .success(let massive) :
                        compitionHandler(Result.success(massive))
                        case .failure(let error) :
                            compitionHandler(Result.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    private func receveingVideoStrings(with data: Data, complitionHandler: @escaping (_ result: Result<[String]>) -> Void)  {
        var urlsVideoList: [String] = []
        let decoder = JSONDecoder()
        do {
            let videosData = try decoder.decode(VideoDataModel.self, from: data)
            let videosUrls = videosData.data
            urlsVideoList.append(contentsOf: videosUrls)
            complitionHandler(Result.success(urlsVideoList))
        }
        catch let error {
            complitionHandler(Result.failure(error as NSError))
        }
    }
}
