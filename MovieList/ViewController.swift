//
//  ViewController.swift
//  MovieList
//
//  Created by SAMUEL LIM on 10/21/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    

    func save(name: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "SavedMovie",
                                   in: managedContext)!
      
      let movie = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      movie.setValue(name, forKeyPath: "name")
      
      // 4
      do {
        try managedContext.save()
          AppData.savedMovies.append(movie)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      print("test")
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "SavedMovie")
      
      //3
      do {
          AppData.savedMovies = try managedContext.fetch(fetchRequest)
          print(AppData.savedMovies.count)
          
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }



    override func viewDidLoad() {
        super.viewDidLoad()        
        
        
        // Do any additional setup after loading the view.
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        searchBar.delegate = self
        searchBarSearchButtonClicked(searchBar) // Calls the first search
        
        
    }
    
    // Basic info for the search screen
    struct basicMovieInfo {
        var title: String
        var year: String
        var id: String
    }
    var moviesList : [basicMovieInfo] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    // Creates the custom cells for the search
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = moviesList[indexPath.row]
        cell.movieTitle?.text = movie.title
        cell.year?.text = movie.year
        cell.movieId = movie.id
        
        let isFavorited = AppData.savedMovies.contains(where: { $0.value(forKey: "id") as! String == movie.id})
        if isFavorited {cell.favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)} else{
            cell.favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.favorited = isFavorited // Sets the boolean of the star to whether or not the list of saved movies has a movie with the same id
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    struct SearchReponse: Codable { // or Decodable
        let Search: [Dictionary<String, String>]
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let requestUrl = "https://www.omdbapi.com/?s=\(String(describing: searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!))&type=movie&apikey=65da5fbe" // Encodes the URL for the search API
        let url = URL(string: requestUrl)
        let data = (try? Data(contentsOf: url!))!
        do {
            let res = try JSONDecoder().decode(SearchReponse.self, from: data)
            
            // Updates the data source for the search table
            moviesList = []
            res.Search.forEach{
                moviesList.append(basicMovieInfo(title: $0["Title"]!, year: $0["Year"]!, id: $0["imdbID"]!))
                
            }
            moviesTableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    
    
    // To be used later to interact between the segue and tableview cell interaction
    var selectedTitle = ""
    var selectedImageUrl = ""
    var selectedRating = ""
    var selectedSummary = ""
    
    
    // All the possible info from the specific movie API
    struct MovieReponse: Codable {
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
        let requestUrl = "https://www.omdbapi.com/?i=\(moviesList[indexPath.row].id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&plot=full&type=movie&apikey=65da5fbe" // Encodes the URL to get the movie info by IMDB ID
        let url = URL(string: requestUrl)
        let data = (try? Data(contentsOf: url!))!
        do {
            let res = try JSONDecoder().decode(MovieReponse.self, from: data)
            
            // Sets the variables to be gotten by the prepare for segue function
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
        // TODO: Check if segue destination is details or favorites
        let destinationNavigationController = segue.destination as! MovieDetailsViewController
        let targetController = destinationNavigationController
        
        // Sets the variables in the second view controller
        targetController.movieTitle = selectedTitle
        targetController.imageUrl = selectedImageUrl
        targetController.rating = selectedRating
        targetController.summary = selectedSummary
        
    }
    
    
}

