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
    
    func save() {
      
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
        movie.setValue(movieTitle.text, forKeyPath: "name")
        movie.setValue(movieId, forKey: "id")
        movie.setValue(year.text, forKey: "year")
      
      // 4
      do {
        try managedContext.save()
          AppData.savedMovies.append(movie)
          print(AppData.savedMovies.count)
          
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func unsave(){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        
        do {
            if let fooOffset = AppData.savedMovies.firstIndex(where: {($0.value(forKey: "id") as! String) == movieId}) {
                print(managedContext.delete(AppData.savedMovies[fooOffset]))
                AppData.savedMovies.remove(at: fooOffset)
                
                print(AppData.savedMovies.count)
                print(fooOffset)
            } else {
                print("\(movieId!) could not be found")
            }
          try managedContext.save()
            
            

            
        } catch let error as NSError {
          print("Could not remove. \(error), \(error.userInfo)")
        }
    }
    
    
    
    @IBAction func favoritesAction(_ sender: Any) {
        print(movieId!)
        if(favorited){
            favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
            unsave()
        } else{
            favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            save()
        }
        favorited.toggle()
        
        print(favorited!)
        
        
        
        
    }
}

class MoviesTableViewController: UITableViewController {
    
}
