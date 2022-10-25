//
//  ViewController.swift
//  MovieList
//
//  Created by SAMUEL LIM on 10/21/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        searchBar.delegate = self
        searchBarSearchButtonClicked(searchBar)
    }
    struct basicMovieInfo {
        var title: String
        var year: String
        var id: String
    }
    var moviesList = [
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        basicMovieInfo(title: "Title", year: "Year",id:"undefined"),
        
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = moviesList[indexPath.row]
        cell.movieTitle?.text = movie.title
        cell.year?.text = movie.year
        return cell
    }
    
    
    struct SearchReponse: Codable { // or Decodable
        let Search: [Dictionary<String, String>]
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(String(describing: searchBar.text!))
        let requestUrl = "https://www.omdbapi.com/?s=\(String(describing: searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!))&type=movie&apikey=65da5fbe"
        print(requestUrl)
        let url = URL(string: requestUrl)
        let data = (try? Data(contentsOf: url!))!
        do {
            let res = try JSONDecoder().decode(SearchReponse.self, from: data)
            
            res.Search.enumerated().forEach{
                moviesList[$0].title = $1["Title"]!
                moviesList[$0].year = $1["Year"]!
                moviesList[$0].id = $1["imdbID"]!
            }
            moviesTableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    
    
    
    var selectedTitle = ""
    var selectedImageUrl = ""
    var selectedRating = ""
    var selectedSummary = ""
    
    
    struct MovieReponse: Codable { // or Decodable
        let Title: String
        let Year: String
        let Rated: String
        let Released: String
        let Runtime: String
        let Genre: String
        let Director: String
        let Writer: String
        let Actors: String
        let Plot: String
        let Language: String
        let Country: String
        let Awards: String
        let Poster: String
        let Ratings: [Dictionary<String, String>]
        let Metascore: String
        let imdbRating: String
        let imdbID: String
        let DVD: String
        let BoxOffice: String
        let Production: String
        let Website: String
        let Response: String
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let requestUrl = "https://www.omdbapi.com/?i=\(moviesList[indexPath.row].id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&plot=full&type=movie&apikey=65da5fbe"
        print(requestUrl)
        let url = URL(string: requestUrl)
        let data = (try? Data(contentsOf: url!))!
        do {
            let res = try JSONDecoder().decode(MovieReponse.self, from: data)
            
            selectedTitle = res.Title
            selectedImageUrl = res.Poster
            selectedSummary = res.Plot
            selectedRating = res.imdbRating
            self.performSegue(withIdentifier: "movieDetails", sender: self)
        } catch let error {
            print(error)
        }
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavigationController = segue.destination as! MovieDetailsViewController
        let targetController = destinationNavigationController
        
        targetController.movieTitle = selectedTitle
        targetController.imageUrl = selectedImageUrl
        targetController.rating = selectedRating
        targetController.summary = selectedSummary
        
    }
    
    
}

