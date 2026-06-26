//Started by Gabriel Jackson on 6/24/26.

//Gabes takeaways:

//I wanted to do so much more, but honestly, this is pretty hard.

//Storyboard makes UI/UX work easier and helps connect all the concepts, since everything can be done programatically too. However, your structure can get convoluted or confusing if you implement UI/VC's both programatically and through the Storyboard (especially with the AI editor )

//DO NOT FORGET TO CLICK INHERIT MODULE FROM TARGET (from the class) WHEN TRYING TO ASSIGN AN OUTLET TO THE ROOT VIEW CONTROLLER SCENE (ctrl click)

//Also, this program would be cleaner if we used a JSON for the data, but I decided not to in order to focus more on understanding the data structures / flow of everything, and with building the UI.


import UIKit

//This file holds the main view of our RecipeListPage & RecipeDetailsPage.
//Thus, we need to initialize our global data type for our list of recipes, which is why we define Recipe as a struct / data container. This way, each row gets its own copy and no inheritance is needed
struct Recipe {
    let title: String              // Display name shown in the list row and details title bar.
    let imageName: String          // Bundle file name (no extension) of the recipe photo (e.g. "green_curry").
    let description: String        // A realistic paragraph describing the dish, shown on the details screen.
    let ingredients: [String]      // Ingredients with measurement units baked into each string.
    let steps: [String]            // Ordered cooking steps with measurements/times baked into each string.
}

//We declare our global constant recipeData as a [Recipe] array, initialized with the data below
let recipeData: [Recipe] = [
    
    // --- Recipe 1: Thai Green Curry --------------------------------------------------
    Recipe(
        title: "Thai Green Curry",
        imageName: "green_curry", //image is loaded from bundle
        description: "A fragrant Thai street-food classic built on a quick coconut-milk curry. Spicy green chiles and Thai basil hit a balance of sweet, salty, and herbal — served over jasmine rice for a weeknight-friendly bowl.",
        ingredients: [
            "1 cup Thai basil leaves",
            "3 tbsp green curry paste",
            "1 cup jasmine rice",
            "1 (13.5 oz) can coconut milk",
            "1 lb boneless chicken thigh, sliced",
            "1 tbsp fish sauce",
            "1 tsp brown sugar"
        ],
        steps: [
            "Rinse 1 cup jasmine rice and cook in 1¾ cups water for 15 minutes; rest covered 5 minutes.",
            "In a wok over medium heat, fry 3 tbsp green curry paste in 2 tbsp coconut cream for 2 minutes until fragrant.",
            "Add 1 lb sliced chicken and stir-fry for 4 minutes until lightly browned on the outside.",
            "Pour in the remaining coconut milk (about 1¼ cups), 1 tbsp fish sauce, and 1 tsp brown sugar; simmer 8 minutes.",
            "Stir in 1 cup Thai basil leaves off the heat and serve over the cooked jasmine rice."
        ]
    ),
    
    // --- Recipe 2: Chicken Alfredo ---------------------------------------------------
    Recipe(
        title: "Chicken Alfredo",
        imageName: "chicken_alfredo",
        description: "A creamy Italian-American comfort plate: pan-seared chicken folded into silky fettuccine bathed in butter, garlic, cream, and grated Parmesan. Ready in about 30 minutes from pantry staples.",
        ingredients: [
            "12 oz fettuccine pasta",
            "1 lb boneless chicken breast",
            "1 cup heavy cream",
            "4 tbsp unsalted butter",
            "1 cup grated Parmesan cheese",
            "2 cloves garlic, minced",
            "1 tsp salt",
            "½ tsp black pepper"
        ],
        steps: [
            "Bring 4 qt salted water to a boil and cook 12 oz fettuccine until al dente (about 10 minutes); reserve ½ cup pasta water before draining.",
            "Season 1 lb chicken breast with 1 tsp salt and ½ tsp pepper; sear 5 minutes per side in 1 tbsp butter, then slice into strips.",
            "In the same pan, melt 3 tbsp butter and sauté 2 minced garlic cloves for 30 seconds until aromatic.",
            "Pour in 1 cup heavy cream and simmer 3 minutes until slightly thickened.",
            "Whisk in 1 cup grated Parmesan, then toss in the pasta and chicken, loosening with the reserved pasta water as needed."
        ]
    ),
    // --- Recipe 3: Gigi's Pumpkin Bread ----------------------------------------------
    Recipe(
        title: "Gigi's Pumpkin Bread",
        imageName: "pump_bread",
        description: "Pay your respects, punk. Gigis recipe gives you a moist, lightly spiced pumpkin loaf passed down from generations in the kitchen.",
        ingredients: [
            "1¾ cups all-purpose flour",
            "1 cup pumpkin puree",
            "1 cup granulated sugar",
            "½ cup vegetable oil",
            "2 large eggs",
            "1 tsp baking soda",
            "1 tsp ground cinnamon",
            "½ tsp ground nutmeg",
            "½ tsp salt"
        ],
        steps: [
            "Preheat oven to 350°F (175°C) and grease a 9×5 inch loaf pan with a thin coat of vegetable oil.",
            "Whisk 1¾ cups flour, 1 tsp baking soda, 1 tsp cinnamon, ½ tsp nutmeg, and ½ tsp salt in a medium bowl.",
            "In a second bowl, beat 1 cup pumpkin puree, 1 cup sugar, ½ cup oil, and 2 eggs until smooth (about 1 minute).",
            "Fold the dry mixture into the wet mixture just until combined — do not overmix, or the loaf will turn dense.",
            "Pour the batter into the loaf pan and bake 55–60 minutes until a toothpick comes out clean; cool 15 minutes before slicing."
        ]
    ),
]

//Now that we have the data our UI components will rely on, we can start building them by first defining the class / VC below, which holds the outlet that displays the tableview of our recipe list.
class RecipeListPage: UIViewController {

//Our RecipeModel will never be nil because we seed it with recipeData below (which is why we can safely use !)
    var RecipeModel: [Recipe]! = recipeData
    
    //tableview Outlet wired in Main.storyboard to display our recipe list.
    @IBOutlet var table: UITableView!

    //This is a typo-safe constant for the cell reuse identifier to get rid of the cell ID warning. We pass it to both register() below and dequeueReusableCell() down in the extension, so the strings never get out of sync.
    private let cellID = "RecipeRow"

    //viewDidLoad runs once after the view loads into memory to wire up the table and format/style
    override func viewDidLoad() {
        super.viewDidLoad()
    //In order for the table to know where to call back into our class for row counts, cell content, and tap handling, we assign the table datasource & delegate as self (RecipeListPage)
        table.dataSource = self
        table.delegate = self
        
    //Im using the applyBackground function from EdenTheme to set the RecipeListPage (view) background as a cream color
        EdenTheme.applyBackground(to: view)
        
    //Then, I use the styleTable function to set the tables background to cream and its separator lines to sand.
        EdenTheme.styleTable(table)
        
    //Also, we have to register a plain UITableViewCell under our cellID. Fortunately, default cells already have a textLabel and imageView built in. Therefore, we can use our defined cellID to register each cell in the table without making a sub class
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        

        //Set rowHeight to 80 because it gives plenty of vertical room for the photo thumbnail plus the bubbly title font.
        table.rowHeight = 80

    //Here, I also made a UILabel for our in-view page title and style it through EdenThemes styleTitle (bubbly forest green text)
        let pageTitle = UILabel()
        pageTitle.text = "All Recipes"
        EdenTheme.styleTitle(pageTitle)
        pageTitle.textAlignment = .center
        
    //tableHeaderView needs an explicit frame since the table won't auto-size it for us — we give it the full table width and 60pt of height so the title has breathing room above the first recipe row.
        pageTitle.frame = CGRect(x: 0, y: 0, width: table.bounds.width, height: 60)
        table.tableHeaderView = pageTitle
    }
}
//Now we need to format/build the data for our table using the extension & functions below, which conform to our UITableViewDataSource/Delegate.
extension RecipeListPage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipeModel.count
       //Number of rows = number of recipes in our model. One row per recipe.
    }
    //This function allows us to modify the cells / rows in our RecipeListPage table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    //Thus, we dequeue a recycled cell instead of allocating a fresh one every scroll, which keeps the tableview smooth on long lists.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
    //Then, we pull out the recipe for the specific row only to read its fields below without re-indexing every line.
        let recipe = RecipeModel[indexPath.row]

    //Also, we use optional chaining (app doesnt crash if it doesnt exist) here in order to assign each recipes title to its cell's textLabel
        cell.textLabel?.text = recipe.title
        
    //Same optional chaining for imageView to display image thumbnail in the list
        cell.imageView?.image = UIImage(named: recipe.imageName)

    //Lastly, we apply our themed look on every dequeue, so a recycled cell can't leak stale styling from a previous row.
        EdenTheme.styleListCell(cell)
        //Return the cell back to the table so it can render this row.
        return cell
    }

//This function fires when the user taps a row and we pushs the RecipeDetailsPage onto the nav stack.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    //First, we load the RecipeDetailsPage UIStoryboard into a local constant
        let recipeDetailsStoryboard = UIStoryboard(name: "RecipeDetailsPage", bundle: Bundle.main)
        
    //Then, we instantiate the initial view controller from RecipeDetails storyboard. We also force-cast to our RecipeDetailsPage class and set the properties below.
    //***However, this will break if the VC ever changes class or the class name changes.***
        let recipeDetailsPage = recipeDetailsStoryboard.instantiateInitialViewController() as! RecipeDetailsPage
        
    //Finally, we pass the tapped recipe into the details page so it knows which recipe to display.
        recipeDetailsPage.recipeDetails = RecipeModel[indexPath.row]
        
        //And then use optional chaining for our Nav controller to push the recipeDetails page view
        navigationController?.pushViewController(recipeDetailsPage, animated: true)
    }
}

//Now, we need a class / Outlet to display all the details of a given recipe after we click on a recipeRow at RecipeListPage
class RecipeDetailsPage: UIViewController {

//This variable holds the recipe that was tapped on the list page since RecipeListPage sets this before pushing us onto the nav stack.
    var recipeDetails: Recipe!

    //Outlets wired in RecipeDetailsPage.storyboard
    @IBOutlet weak var stepsTable: UITableView!
    @IBOutlet weak var ingredientsStack: UIStackView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

//Here, we create anoither reuse identifier for step rows and is kept separate from the list cell ID, this way, each table dequeues its own pool of cells without crossover.
    private let stepCellID = "StepRow"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = recipeDetails.title

//Again, we are using EdenTheme class to apply theme to the view (details page) so everything blends
        EdenTheme.applyBackground(to: view)

//This loads each recipe image because UIImage(named:) can find it from the bundle using the base filename *no extensions needed*.
        recipeImageView.image = UIImage(named: recipeDetails.imageName)
        
//I use scaleAspectFill to keep the photo's aspect ratio and fill the frame edge-to-edge, which looks better than default scaleToFill stretch.
        recipeImageView.contentMode = .scaleAspectFill

//However, this also means we need clipsToBounds to prevent overflow from bleeding over neighboring views.
        recipeImageView.clipsToBounds = true
    //Also added rounded corners to soften the heavy photo block and keep the bubbly style consistent with the rest of the app.
        recipeImageView.layer.cornerRadius = 12
        
// Description paragraph --------------------------------------------
    //Using our recipeDetails variable, we can push the description string into the label and style it with the EdenTheme.styleBody() function
        descriptionLabel.text = recipeDetails.description
        EdenTheme.styleBody(descriptionLabel)

// Ingredients Stack ----------------------------------------------
    // Creates a UI header label for ingredients
        let ingredientsHeader = UILabel()
        ingredientsHeader.text = "Ingredients"
    //Similar to descriptions, we apply EdenThemes SectionHeader function to our ingredientsHeader label
        EdenTheme.styleSectionHeader(ingredientsHeader)
    //Then, we call insertArrangedSubview at index 0 to insert the Ingredient header at the top of the existing ingredientsStack, keeping the storyboard's stack as the layout root.
        ingredientsStack.insertArrangedSubview(ingredientsHeader, at: 0)
        
    //However, we still havent displayed the data yet. Thus, for each ingredient in our recipeDetails from RecipeModel...
        recipeDetails.ingredients.forEach { ingredient in
            let label = UILabel()
        //We add a bullet glyph before each ingredient so the stack reads like a proper ingredient list
            label.text = "• \(ingredient)"
        //Styles the body of ingredients view with the EdenTheme styleBody colors.
            EdenTheme.styleBody(label)
        //We use addArrangedSubview because it calculates the constraints to properly display stacked views (which is what ingredientsStack is)
            ingredientsStack.addArrangedSubview(label)

        }

// ---- Steps table ------------------------------------------------------
    //First, we wire up data source & delegate, so the table calls back into this class.
        stepsTable.dataSource = self
        stepsTable.delegate = self
        
    //Registers the default cell under our stepCellID, but since we only need text, the built-in cell is enough (again, no custom subclass needed)
        stepsTable.register(UITableViewCell.self, forCellReuseIdentifier: stepCellID)
        
        //We use the styleTable function from EdenTheme to use the custom background & separators for our table.
        EdenTheme.styleTable(stepsTable)
        
    //In case I decide to modify this with a long ass JSON, we make sure that stepsTable can handle various lengths of steps in our RecipeDetails stepsTable. Thus, we use automaticDimension to let each row size itself to its (potentially long) step text instead of clipping to a fixed height.
        stepsTable.rowHeight = UITableView.automaticDimension
        
        //I also set an estimated row height to help UIKit pre-allocate before the real measurement. Without this, the table can scroll-jump as it measures cells lazily.
        stepsTable.estimatedRowHeight = 60
    }
}

//Now we need to format/build the data for our steps table using the extension & functions below
extension RecipeDetailsPage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of rows = number of steps in this recipe. One row per step.
        recipeDetails.steps.count
    }
    //Now that we know how many rows we need to format for each recipe details steps...
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //We can dequeue a recycled cell using our stepCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellID, for: indexPath)
        
        //Then, we pull out this rows step from our recipe so we can read it below.
        let step = recipeDetails.steps[indexPath.row]
        
        //This numbers each step in the cell. Since indexPath.row is 0-based, we add 1 so the user sees "1.", "2.", etc. instead of starting at 0.
        cell.textLabel?.text = "\(indexPath.row + 1). \(step)"
        
        //We also apply the themed cell styling (cream bg, bark text, bubbly font, multi-line wrap) from EdenTheme.
        EdenTheme.styleStepCell(cell)
        return cell
    }

    //Lastly, this is the section header text for the stepsTable. UIKit will render "Steps" above the section automatically, so I dont have to build a custom header view.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Steps"
    }
}
