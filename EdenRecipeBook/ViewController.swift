//Gabes takeaways:
//Storyboard makes UI/UX work easier and helps connect all the concepts, since everything can be done programatically too.

//CTRL CLICK to make outlets/right click

//DO NOT FORGET TO CLICK INHERIT MODULE FROM TARGET (from the class) WHEN TRYING TO ASSIGN AN OUTLET TO THE ROOT VIEW CONTROLLER SCENE


//  ViewController.swift
//  EdenRecipeBook
//
//  Created by Gabriel Jackson on 6/24/26.
//


import UIKit

//This file holds the main view of our app (Root View Controller)

//First though, we need to initialize our global data type for our list of recipes
struct Recipe {
    let title: String
    let ingredients: [String]
}

//Defines the data in recipe and encapsulates it with the following title values
let recipeData: [Recipe] = [
    Recipe(title: "Thai Green Curry", ingredients: ["Thai Basil", "Green Curry Paste", "Rice", "Coconut Milk"]),
    Recipe(title: "Chicken Alfredo", ingredients: ["Chicken"]),
    Recipe(title: "Gigis Pumpkin Bread", ingredients: ["Pumpkin"]),
]

//We create the class below to make an outlet to display the tableview of our recipe list.
class RecipeListPage: UIViewController {
    var RecipeModel: [Recipe]! = recipeData
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //If everything loaded, we can assign the tables data source to ViewController to display the table
        table.dataSource = self
        table.delegate = self
    }
}
//The extension below conforms to our UITableViewDataSource and allows us to use the function to calculate the number of recipes/rows. That way, we can use the function to read each recipe in the list.
extension RecipeListPage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipeModel.count //
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = RecipeModel[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipeDetailsStoryboard = UIStoryboard(name: "RecipeDetailsPage", bundle: Bundle.main)
        
        //We use Apples ViewController  function to typcase and initialize our RecipeDetailsPage
        let recipeDetailsPage = recipeDetailsStoryboard.instantiateInitialViewController() as! RecipeDetailsPage
        //Accesses each row index of our Recipe models to pick appropriate row when tapped.
        recipeDetailsPage.recipeDetails = RecipeModel[indexPath.row]
        navigationController?.pushViewController(recipeDetailsPage, animated: true)
        
    }
}

//Now, we make a class to add as an Outlet to display all the details of a given recipe when clicked on
class RecipeDetailsPage: UIViewController {
    var recipeDetails: Recipe!
    
    //UI code from assigning outlets
    @IBOutlet weak var stepsTable: UITableView!
    @IBOutlet weak var ingredientsStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = recipeDetails.title
        //Now that we got the basic UI layout working, we need to load the ingredients array we just created into the stackview
        //For each ingredient in our recipeDetails from RecipeModel
        recipeDetails.ingredients.forEach { ingredient in let label = UILabel()
            label.text = ingredient
            //addArrangedSubview is meant for stacked views and calculates the constraints to properly display it
            ingredientsStack.addArrangedSubview(label)
            
        }
    }
}
