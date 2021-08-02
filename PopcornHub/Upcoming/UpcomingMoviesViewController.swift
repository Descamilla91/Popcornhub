//
//  UpcomingMoviesViewController.swift
//  PopcornHub
//
//  Created by Diego Escamilla on 27/07/21.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol UpcomingMoviesDisplayInterface: AnyObject {
    func displayUpcomingMovies(upcomingMoviesViewModel: UpcomingMoviesModels.FetchUpcomingMovies.ViewModel)
	func displayMovieDetail()
}

class UpcomingMoviesViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private(set) weak var titleLabel: UILabel!
	@IBOutlet private(set) weak var upcomingMoviesCollectionView: UICollectionView!
	
	
    // MARK: - Properties
    
    var interactor: UpcomingMoviesInteractorInterface?
    var router: (UpcomingMoviesRouterInterface & UpcomingMoviesDataPassing)?
	var viewModel = UpcomingMoviesModels.FetchUpcomingMovies.ViewModel()
    
    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupVIPCycle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupVIPCycle()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUpcomingMovies()
    }
    
    // MARK: - Setup
    
    private func setupVIPCycle() {
        let viewController = self
        let interactor = UpcomingMoviesInteractor()
        let presenter = UpcomingMoviesPresenter()
        let router = UpcomingMoviesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
		titleLabel.text = LocalStrings.UpcomingMovies.title
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
		setupUpcomingMoviesCollectionView()
    }
	
	private func setupUpcomingMoviesCollectionView() {
		upcomingMoviesCollectionView.delegate = self
		upcomingMoviesCollectionView.dataSource = self
		upcomingMoviesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
		upcomingMoviesCollectionView.register(UINib(nibName: NibNames.MediaCollectionCellId, bundle: nil), forCellWithReuseIdentifier: NibNames.MediaCollectionCellId)
	}
    
    // MARK: - Helpers
    
    func fetchUpcomingMovies() {
        interactor?.fetchUpcomingMovies()
    }
	
	func selectUpcomingMovie(index: Int) {
		let request = UpcomingMoviesModels.SelectUpcomingMovie.Request(index: index)
		interactor?.selectUpcomingMovie(request: request)
	}
}


// MARK: - UpcomingMoviesDisplayLogic

extension UpcomingMoviesViewController: UpcomingMoviesDisplayInterface {
    func displayUpcomingMovies(upcomingMoviesViewModel: UpcomingMoviesModels.FetchUpcomingMovies.ViewModel) {
		viewModel = upcomingMoviesViewModel
		upcomingMoviesCollectionView.reloadData()
    }
	
	func displayMovieDetail() {
		router?.routToMovieDetail()
	}
}

extension UpcomingMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.displayableMediaList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibNames.MediaCollectionCellId, for: indexPath) as? MediaCollectionViewCell else {
			return UICollectionViewCell()
		}
		let popularMovie = viewModel.displayableMediaList[indexPath.item]
		cell.update(displayableMedia: popularMovie)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectUpcomingMovie(index: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.size.width * 0.7
		let height = width * 1.48
		return CGSize(width: width, height: height)
	}
}