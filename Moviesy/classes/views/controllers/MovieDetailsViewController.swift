//
//  MovieDetailsViewController.swift
//  Moviesy
//
//  Created by Rishab on 25/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, OnCommunicationResponseListener
{
    @IBOutlet weak var _detailsTableView: UITableView!
    
    var viewModel:MovieViewModel!

    private let _noOfRowsInTableView            = 3
    private let _tableViewCellHeight:CGFloat    = 229.0
    private var _spinnerView:UIView?
    private var _backButton:UIButton!
    private var _headerView:MovieDetailsHeaderView!
    
    //MARK: -
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateView()
        fetchData()
    }
    
    //MARK: -
    //MARK:  UI Customization
    
    private func updateView()
    {
        _backButton = getBackButton()
        _headerView = getHeaderView()
        updateNavigationBar()
        updateTableView()
        viewModel.configure(_headerView)
    }
    
    private func updateTableView()
    {
        _detailsTableView.tableHeaderView = _headerView
        _detailsTableView.register(UINib(nibName: StringValues.CastCrewTableViewCellId, bundle: Bundle.main), forCellReuseIdentifier: StringValues.CastCrewTableViewCellId)
        _detailsTableView.register(UINib(nibName: StringValues.SimilarMovieTableViewCellId, bundle: Bundle.main), forCellReuseIdentifier: StringValues.SimilarMovieTableViewCellId)
    }
    
    private func updateNavigationBar()
    {
        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "logo-small"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: _backButton)
    }
    
    private func getBackButton() -> UIButton
    {
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .selected)
        
        button.frame = CGRect.init(x: 0.0, y: 0.0, width: 32.0, height: 32.0)
        button.addTarget(self, action: #selector(MovieDetailsViewController.didClickOnBackButton), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.white
        return button
    }
    
    private func getHeaderView() -> MovieDetailsHeaderView
    {
        let headerView = MovieDetailsHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.size.width, height: 480)))
        return headerView
    }
    
    private func removeSpinner()
    {
        hideSpinner(spinner: _spinnerView)
        _spinnerView = nil
    }
    
    //MARK: -
    //MARK: Actions
    
    @IBAction func didClickOnBackButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion:nil)
    }
    
    
    //MARK: -
    //MARK: Misc
    
    private func fetchData()
    {
        do
        {
            try CommunicationManager.shared.perform(operation: MovieDetailOperation.init(withListener: self, forMovieId:viewModel.id))
        }
        catch
        {
            showNoNetworkAlert()
        }
    }
    
    //MARK: -
    //MARK: OnCommunicationResponseListener Methods
    
    func onSuccess(id: Int, processor: ICommunicationResponseProcessor)
    {
        removeSpinner()
        
        if (id == Communication.OperationID.MovieDetail)
        {
            let detailResponseProcessor = processor as! MovieDetailResponseProcessor
            viewModel = MovieViewModel(withMovie: detailResponseProcessor.data!)
            
            _detailsTableView.reloadData()
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

extension MovieDetailsViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _noOfRowsInTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
            case 0:
                let cell:CastCrewTableViewCell = tableView.dequeueReusableCell(withIdentifier: StringValues.CastCrewTableViewCellId) as! CastCrewTableViewCell
                cell.viewModel = viewModel.cast
                return cell
            case 1:
                let cell:CastCrewTableViewCell = tableView.dequeueReusableCell(withIdentifier: StringValues.CastCrewTableViewCellId) as! CastCrewTableViewCell
                cell.viewModel = viewModel.crew
                return cell
            case 2:
                let cell:SimilarMovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: StringValues.SimilarMovieTableViewCellId) as! SimilarMovieTableViewCell
                cell.viewModel = viewModel.similar
                return cell
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row
        {
            case 0:
                return viewModel.hasCast ? _tableViewCellHeight : 0.0
            case 1:
                return viewModel.hasCrew ? _tableViewCellHeight : 0.0
            case 2:
                return viewModel.hasSimilar ? _tableViewCellHeight : 0.0
            default:
                return 44.0
            
        }
    }

}

