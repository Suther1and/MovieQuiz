//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Barto on 14.04.2024.
//

import UIKit


class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func presenterAlert(with model: AlertModel) {
        delegate?.showAlert(with: model)
    }
}
