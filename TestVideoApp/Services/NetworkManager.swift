//
//  NetworkManager.swift
//  TestVideoApp
//
//  Created by Станислав Климов on 24.09.2020.
//

import Foundation

class NetworkManager {
    var urlsVideoList: [String] = []
    
    func fetchVideoData(from url: String, compitionHandler: @escaping (_ exist: [String]) -> Void){
        guard let url = URL(string: url) else { return }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                self.receveingVideoStrings(with: data)
                compitionHandler(self.urlsVideoList)
            }.resume()
    }
    
    
    private func receveingVideoStrings(with data: Data) {
        let decoder = JSONDecoder()
        do {
            let videosData = try decoder.decode(VideoDataModel.self, from: data)
            let videosUrls = videosData.data
            self.urlsVideoList.append(contentsOf: videosUrls)
        }
        catch let error {
            print(error)
        }
    }
}
