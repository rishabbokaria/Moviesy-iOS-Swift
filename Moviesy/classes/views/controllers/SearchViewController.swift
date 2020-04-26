//
//  SearchViewController.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController
{
    @IBOutlet weak var _moviesTableView: UITableView!
    @IBOutlet weak var _searchTextField: UITextField!
    
    var viewModels:[MovieViewModel]!
    private var _backButton:UIButton!
    fileprivate var _filteredViewModels:[MovieViewModel] = []
    fileprivate var _selectedItem:Int = -1;

    //MARK: -
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: -
    //MARK:  UI Customization
    
    private func updateView()
    {
        updateNavigationBar()
        updateTextField()
        updateTableView()
    }
    
    private func updateNavigationBar()
    {
        _backButton = getBackButton()
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
        button.addTarget(self, action: #selector(SearchViewController.didClickOnBackButton), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.white
        return button
    }
    
    private func updateTextField()
    {
        let frame = CGRect.init(origin: .zero, size: CGSize.init(width: 8.0, height: _searchTextField.frame.size.height))
        let leftView = UIView(frame: frame)
        leftView.backgroundColor = .clear

        _searchTextField.layer.cornerRadius = 5.0
        _searchTextField.leftViewMode = .always
        _searchTextField.leftView = leftView
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
    
    fileprivate func isSearching() -> Bool
    {
        return !(_searchTextField.text ?? "").isEmpty
    }
    
    //MARK: -
    //MARK: Navigation Methods
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == StringValues.MovieDetailsSegueId)
        {
            let movieDetailVC:MovieDetailsViewController = segue.destination as! MovieDetailsViewController
            if (isSearching())
            {
                if (_selectedItem < 0 && _selectedItem > _filteredViewModels.count-1)
                {
                    _selectedItem = 0;
                }
                movieDetailVC.viewModel = _filteredViewModels[_selectedItem]
            }
            else
            {
                if (_selectedItem < 0 && _selectedItem > viewModels.count-1)
                {
                    _selectedItem = 0;
                }
                movieDetailVC.viewModel = viewModels[_selectedItem]
            }
        }
    }
    
    //MARK: -
    //MARK: Actions
    
    @objc private func didClickOnBackButton(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didChangeEditingInTextField(_ sender: Any)
    {
        filterItems(withQuery: _searchTextField.text ?? "")
    }
    
    //MARK: -
    //MARK: Misc
    
    fileprivate func filterItems(withQuery query:String)
    {
        if (query.isEmpty)
        {
            _filteredViewModels = viewModels
            _moviesTableView.reloadData()
        }
        else
        {
            let lowerCasedQuery = query.trimmingCharacters(in:.whitespacesAndNewlines).lowercased()
            let lowerCasedQueryWords = lowerCasedQuery.split(separator: " ")
            
            if (lowerCasedQueryWords.count > 1)
            {
                _filteredViewModels = viewModels.filter({ (movieViewModel) -> Bool in
                    let titleWords = movieViewModel.title.lowercased().split(separator: " ")
                    let filteredTitleWords = titleWords.filter { (titlePart) -> Bool in
                        let test = lowerCasedQueryWords.filter { (queryPart) -> Bool in
                            return titlePart.starts(with: queryPart)
                        }
                        return test.count > 0
                    }
                    return filteredTitleWords.count > 0
                })
            }
            else
            {
                _filteredViewModels = viewModels.filter({ (movieViewModel) -> Bool in
                    let titleWords = movieViewModel.title.lowercased().split(separator: " ")
                    let filteredTitleWords = titleWords.filter { (titlePart) -> Bool in
                        return titlePart.starts(with: lowerCasedQuery)
                    }
                    return filteredTitleWords.count > 0
                })
            }
            _moviesTableView.reloadData()
        }
    }
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return isSearching() ? _filteredViewModels.count : viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringValues.MovieTableViewCellId) as! MovieTableViewCell
        cell.viewModel = isSearching() ? _filteredViewModels[indexPath.row] : viewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        _selectedItem = indexPath.row
        self.performSegue(withIdentifier: StringValues.MovieDetailsSegueId, sender:nil)
    }
}


extension SearchViewController : UITextFieldDelegate
{    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
