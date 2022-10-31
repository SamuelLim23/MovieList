//
//  MoviesTableViewController.swift
//  MovieList
//
//  Created by SAMUEL LIM on 10/21/22.
//

import UIKit

struct Movie {
    // ...
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var year: UILabel!
    var movieId: String!
    var favorited: Bool!
    @IBAction func favoritesAction(_ sender: Any) {
        print(movieId!)
        if(favorited){
            favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else{
            favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        favorited.toggle()
        print(favorited!)
        
        
        
        
    }
}

class MoviesTableViewController: UITableViewController {
    
}
