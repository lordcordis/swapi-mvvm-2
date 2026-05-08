//
//  Generator.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 05.06.2022.
//

import Foundation

struct Generator {
    static func generateViewModelHelper(url: String, contentType: ContentType) async -> DetailTableViewControllerViewModel? {
        guard let data = try? await Networking.getData(url: url),
              let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: contentType) else {
            return nil
        }
        let viewModel = DetailTableViewControllerViewModel(response: response, contentType: contentType)
        await viewModel.loadRelatedData(for: response)
        return viewModel
    }
}
