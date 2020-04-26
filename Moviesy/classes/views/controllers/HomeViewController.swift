//
//  HomeViewController.swift
//  Moviesy
//
//  Created by Rishab on 22/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, OnCommunicationResponseListener
{
    @IBOutlet weak var _moviesTableView: UITableView!
    private var _spinnerView:UIView?
    private var _searchButton:UIButton!

    private var _page:Int = 1;
    private var _totalPages:Int = 1;
    fileprivate var _selectedItem:Int = -1;
    fileprivate var _viewModels:[MovieViewModel] = []
    
    //MARK: -
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateView()
        
        fetchData(forPageNumber: _page)
    }
    
    //MARK: -
    //MARK:  UI Customization
    
    private func updateView()
    {
        updateNavigationBar()
        updateTableView()
    }
    
    private func updateNavigationBar()
    {
        _searchButton = getSearchButton()
        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "logo-small"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: _searchButton)
    }
    
    private func updateTableView()
    {
        _moviesTableView.register(UINib.init(nibName: StringValues.MovieTableViewCellId, bundle: Bundle.main), forCellReuseIdentifier: StringValues.MovieTableViewCellId)
        let frame = CGRect.init(origin: .zero, size: CGSize.init(width: self.view.bounds.size.width, height: 8.0))
        let headerView = UIView(frame: frame)
        let footerView = UIView(frame: frame)
        
        headerView.backgroundColor = .clear
        footerView.backgroundColor = .clear
        
        _moviesTableView.tableHeaderView = headerView
        _moviesTableView.tableFooterView = footerView
    }
    
    private func getSearchButton() -> UIButton
    {
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_search"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_search"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "ic_search"), for: .selected)

        button.frame = CGRect.init(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(self, action: #selector(HomeViewController.didClickOnSearchButton), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.white
        return button
    }
    
    private func removeSpinner()
    {
        hideSpinner(spinner: _spinnerView)
        _spinnerView = nil
    }
    
    //MARK: -
    //MARK: Navigation Methods
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == StringValues.MovieDetailSegueId)
        {
            if (_selectedItem < 0 && _selectedItem > _viewModels.count-1)
            {
                _selectedItem = 0;
            }
            let movieDetailVC:MovieDetailsViewController = segue.destination as! MovieDetailsViewController
            movieDetailVC.viewModel = _viewModels[_selectedItem]
        }
    }
    
    //MARK: -
    //MARK: Actions
    
    @objc private func didClickOnSearchButton(_ sender:UIButton)
    {
        self.performSegue(withIdentifier: StringValues.SearchSegueId, sender:sender)
    }
    
    //MARK: -
    //MARK: Misc

    fileprivate func fetchData(forPageNumber page:Int)
    {
        do
        {
            try CommunicationManager.shared.perform(operation: MovieNowPlayingOpertaion(withListener: self, pageNumber: page))
            _spinnerView = showSpinner(onView: self.view)
        }
        catch
        {
            showNoNetworkAlert()
        }
    }
    
    fileprivate func loadMoreData()
    {
        _page += 1
        if (_page <= _totalPages)
        {
            fetchData(forPageNumber: _page)
        }
    }
    
    //MARK: -
    //MARK: OnCommunicationResponseListener Methods
    
    func onSuccess(id: Int, processor: ICommunicationResponseProcessor)
    {
        removeSpinner()
        
        if (id == Communication.OperationID.MovieNowPlaying)
        {
            let nowPlayingProcessor = processor as! NowPlayingResponseProcessor

            if let data:MovieNowPlayingResponseData = nowPlayingProcessor.data
            {
                if (_page == 1)
                {
                    _totalPages = data.totalPages ?? 1
                }
                if let movies = data.movies
                {
                    let movieViewModels:[MovieViewModel] = movies.map { return MovieViewModel(withMovie: $0) }
                    _viewModels.append(contentsOf: movieViewModels)
                    _moviesTableView.reloadData()
                    
                    
                }
            }
        }
    }
    
    func onFailure(id: Int, error: CommunicationError)
    {
        removeSpinner()
        
        if (error.errorCode == CommunicationError.NO_NETWORK)
        {
            showNoNetworkAlert()
        }
    }

}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringValues.MovieTableViewCellId) as! MovieTableViewCell
        cell.viewModel = _viewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (indexPath.row == _viewModels.count-1)
        {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        _selectedItem = indexPath.row
        self.performSegue(withIdentifier: StringValues.MovieDetailSegueId, sender:nil)
    }
}
