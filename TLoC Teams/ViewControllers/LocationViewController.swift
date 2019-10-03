//
//  LocationViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 03.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import MapKit

final class LocationViewController: UIViewController {
    
    // MARK: - Typealias
    
    typealias LocationSelectionHandler = (_ location: EventLocation) -> Void
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var helperLocationView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var mapView: MKMapView!
    
    private lazy var geocoder = CLGeocoder()
    private lazy var textFieldDelegate = TextFieldDelegate()
    
    // MARK: - Properties
    
    private var location: EventLocation?
    private var locationSelectionHandler: LocationSelectionHandler?
    
    // MARK: - Life cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = location?.name ?? "Location"
        setupUI()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        
        selectButton.isEnabled = false
        selectButton.setTitle("Select", for: .normal)
        selectButton.tintColor = ColorName.green.color
        
        searchBar.delegate = self
        searchBar.placeholder = "Location.."
        
        
        if location != nil {
            helperLocationView.isHidden = true
            handle(location)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func selectAction(_ sender: Any) {
        
        guard let location = location else {
            return
        }
        
        locationSelectionHandler?(location)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper
    
    @objc private func searchAction() {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        geocoder.geocodeAddressString(text) { [weak self] (placeMarks, error) in
            
            if let placeMark = placeMarks?.first {
                
                guard let coordinate = placeMark.location?.coordinate, let name = placeMark.name else {
                    return
                }
                
                let location = EventLocation(name: name,
                                             long: coordinate.longitude,
                                             lat: coordinate.latitude)
                self?.handle(location)
                self?.location = location
            } else {
                self?.showAlert(with: Alerts.NoLocationFoundTitle, message: Alerts.NoLocationFoundMessage)
            }
        }
    }
    
    private func handle(_ location: EventLocation?) {
        
        guard let location = location else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - StoryboardInitializable

extension LocationViewController: StoryboardInitializable {

    static func makeFromStoryboard() -> LocationViewController {
        return StoryboardScene.Main.locationViewController.instantiate()
    }

    static func makeFromStoryboard(locationSelectionHandler: LocationSelectionHandler?) -> LocationViewController {
        
        let vc = makeFromStoryboard()
        vc.locationSelectionHandler = locationSelectionHandler
        return vc
    }
    
    static func makeFromStoryboard(location: EventLocation) -> LocationViewController {
        
        let vc = makeFromStoryboard()
        vc.location = location
        return vc
    }
}

// MARK: - UISearchbarDelegate

extension LocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction), object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 1.0)
        
        selectButton.isEnabled = searchText.isEmpty == false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
