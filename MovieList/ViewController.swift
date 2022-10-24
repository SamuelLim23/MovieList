//
//  ViewController.swift
//  MovieList
//
//  Created by SAMUEL LIM on 10/21/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }
    
    let moviesList = ["1","2","3","4"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = moviesList[indexPath.row]
        cell.movieTitle?.text = movie
        cell.genre?.text = movie
        cell.rating?.text = movie
        return cell
    }
    
}

