//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Temporary on 10/24/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var summaryText: UITextView!
    
    var movieTitle: String!
    var imageUrl: String!
    var rating: String!
    var summary: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageUrl!)
        let data = try? Data(contentsOf: url!)
        
        coverImage.image = UIImage(data: data!) // Sets the imageview to image provided by the URL
        titleText.text = movieTitle!
        ratingText.text = rating!
        summaryText.text = summary!
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
