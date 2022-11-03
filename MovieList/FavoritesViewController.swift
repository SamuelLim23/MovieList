//
//  FavoritesViewController.swift
//  MovieList
//
//  Created by SAMUEL LIM on 11/2/22.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.savedMovies.count
    }
    
    // Creates the custom cells for the search
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = AppData.savedMovies[indexPath.row]
        cell.movieTitle?.text = (movie.value(forKey: "name") as! String)
        cell.year?.text = (movie.value(forKey: "year") as! String)
        cell.movieId = (movie.value(forKey: "id") as! String)
        
        let isFavorited = AppData.savedMovies.contains(where: { $0.value(forKey: "id") as! String == movie.value(forKey: "id") as! String})
        if isFavorited {cell.favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)} else{
            cell.favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.favorited = isFavorited // Sets the boolean of the star to whether or not the list of saved movies has a movie with the same id
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        let requestUrl = "https://www.omdbapi.com/?i=\((AppData.savedMovies[indexPath.row].value(forKey: "id") as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&plot=full&type=movie&apikey=65da5fbe" // Encodes the URL to get the movie info by IMDB ID
        let data = (try? Data(contentsOf: URL(string: requestUrl)!))!
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
        if(segue.identifier == "movieDetails"){
            let destinationNavigationController = segue.destination as! MovieDetailsViewController
            let targetController = destinationNavigationController
            
            // Sets the variables in the second view controller
            targetController.movieTitle = selectedTitle
            targetController.imageUrl = selectedImageUrl
            targetController.rating = selectedRating
            targetController.summary = selectedSummary
        } else{
            
        }
        
        
    }

}
