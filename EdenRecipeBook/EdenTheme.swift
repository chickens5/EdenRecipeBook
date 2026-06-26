//
//  EdenTheme.swift
//  EdenRecipeBook
//

//I placed all the colors, fonts, and other design choices for our views in this file so its all in one convenient place instead of every View class.
//

import UIKit

//Our earth-tone color palett is grouped in an enum so we can write
// `EarthTones.cream`, `EarthTones.forest`, etc. from any screen.
enum EarthTones {

    // Light warm cream — main background of screens.
    static let cream      = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 1.0)

    // Slightly darker sand — card / row backgrounds.
    static let sand       = UIColor(red: 0.90, green: 0.83, blue: 0.70, alpha: 1.0)

    // Soft sage green — secondary text and accents.
    static let moss       = UIColor(red: 0.55, green: 0.62, blue: 0.40, alpha: 1.0)

    // Deep forest green — the main "brand" color for titles and bars.
    static let forest     = UIColor(red: 0.25, green: 0.38, blue: 0.22, alpha: 1.0)

    // Warm rust orange — buttons and highlights.
    static let terracotta = UIColor(red: 0.78, green: 0.45, blue: 0.30, alpha: 1.0)

    // Dark warm brown — main body text (softer than pure black on cream).
    static let bark       = UIColor(red: 0.36, green: 0.26, blue: 0.18, alpha: 1.0)
}

//I also made this "bubbly" rounded version of the system font for all our text.
// iOS has a built-in rounded design (like the Fitness app numbers).
extension UIFont {
    static func bubbly(size: CGFloat, weight: UIFont.Weight = .heavy) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        // Apply the rounded design; fall back to the plain system font if
        // the device can't (very old iOS).
        guard let descriptor = base.fontDescriptor.withDesign(.rounded) else {
            return base
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

//This is also the central namespace to "apply theme" helpers, which we make use of in ViewController.
enum EdenTheme {
    //This function paints the cream background onto any UIView
    static func applyBackground(to view: UIView) {
        view.backgroundColor = EarthTones.cream
    }

    //This function creates our big headline label (recipe titles etc.). with forest green on cream for a strong earthy contrast
    static func styleTitle(_ label: UILabel) {
        label.font = .bubbly(size: 22, weight: .heavy)   // Big, bold, rounded.
        label.textColor = EarthTones.forest              // Deep brand green.
        label.numberOfLines = 0                          // Allow wrap for long titles.
    }

    //This function styles the normal body (descriptions, ingredient rows, step text) in a bark brown.
    static func styleBody(_ label: UILabel) {
        label.font = .bubbly(size: 16, weight: .medium)  // Readable but still rounded.
        label.textColor = EarthTones.bark                // Warm dark brown.
        label.numberOfLines = 0                          // Multi-line so paragraphs wrap.
    }

    //This function styles a "section header" label (like our label word "Ingredients") with a terracotta color and orange accent.
    static func styleSectionHeader(_ label: UILabel) {
        label.font = .bubbly(size: 18, weight: .bold)    // Slightly smaller than title.
        label.textColor = EarthTones.terracotta          // Rust orange accent.
    }

    //This function styles any UITableView we hand it so its background and separators match our palette instead of the default white + light gray iOS draws.
    static func styleTable(_ table: UITableView) {
        table.backgroundColor = EarthTones.cream         // Cream so the table blends with the screen behind it.
        table.separatorColor  = EarthTones.sand          // Sand gives us subtle warm divider lines between rows.
    }

    //This function skins a row in our "All Recipes" tableview. Like we mentioned in ViewController, UITableViewCell already has a textLabel and imageView built in — so we just re-skin those instead of making a full custom cell subclass.
    static func styleListCell(_ cell: UITableViewCell) {
        cell.backgroundColor = EarthTones.sand           // Sand stands out from the cream table bg so the rows pop.
        cell.textLabel?.font = .bubbly(size: 20, weight: .heavy)  // Bold recipe names so theyre easy to scan.
        cell.textLabel?.textColor = EarthTones.forest    // Forest green on sand reads well.
        cell.imageView?.layer.cornerRadius = 8           // Soft rounded corners on the thumbnail to echo our bubbly font.
        cell.imageView?.clipsToBounds = true             // We need clipsToBounds for the rounded corners to actually crop the image — otherwise the corners are masked visually but the image still overflows.
    }

    //This function skins a row in the steps tableview on RecipeDetailsPage. We use a slightly smaller font than the main list rows since steps are paragraph-y and need more room to breathe.
    static func styleStepCell(_ cell: UITableViewCell) {
        cell.backgroundColor = EarthTones.cream          // Blend with the cream table bg behind it.
        cell.textLabel?.font = .bubbly(size: 15, weight: .medium)
        cell.textLabel?.textColor = EarthTones.bark      // Body-copy brown for easy legibility on long text.
        cell.textLabel?.numberOfLines = 0                // 0 so the cell can wrap across as many lines as the step needs.
    }

    //This function configures the global navigation bar appearance. We call it once at launch from AppDelegate, so every nav bar in our app (list page, details page, anything we add later) automatically gets the forest-green bar with cream lettering — no per-screen setup needed.
    static func applyNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()     // New iOS 13+ appearance API.
        appearance.configureWithOpaqueBackground()       // Solid color rather than the default translucent blur.
        appearance.backgroundColor = EarthTones.forest   // Deep forest green matches our brand.
        //titleTextAttributes is the standard nav bar title styling — cream on forest mirrors our app palette.
        appearance.titleTextAttributes = [
            .foregroundColor: EarthTones.cream,
            .font: UIFont.bubbly(size: 20, weight: .heavy)
        ]
    //We apply our appearance to all 3 bar states so the look stays consistent no matter where the user is.
        UINavigationBar.appearance().standardAppearance   = appearance //Normal state once content has scrolled.
        UINavigationBar.appearance().scrollEdgeAppearance = appearance //When content is at the top edge of the scroll view.
        UINavigationBar.appearance().compactAppearance    = appearance //iPhone landscape (compact-height bar).
        //tintColor controls the back-button chevron and any button labels in the bar.
        UINavigationBar.appearance().tintColor = EarthTones.cream
    }
}
