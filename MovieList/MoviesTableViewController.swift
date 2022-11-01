//
//  MoviesTableViewController.swift
//  MovieList
//
//  Created by SAMUEL LIM on 10/21/22.
//

import UIKit
import CoreData

struct Movie {
    // ...
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var year: UILabel!
    var movieId: String!
    var favorited: Bool!
    
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
          print(AppData.savedMovies.count)
          
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func unsave(name: String){
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
        do {
          try managedContext.save()
            
            print(managedContext.delete(AppData.savedMovies[0]))
            AppData.savedMovies.remove(at: 0)
            
            print(AppData.savedMovies.count)

            
        } catch let error as NSError {
          print("Could not remove. \(error), \(error.userInfo)")
        }
    }
    
    
    
    @IBAction func favoritesAction(_ sender: Any) {
        print(movieId!)
        if(favorited){
            favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
            unsave(name: movieId)
        } else{
            favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            save(name: movieId)
        }
        favorited.toggle()
        
        print(favorited!)
        
        
        
        
    }
}

class MoviesTableViewController: UITableViewController {
    
}
