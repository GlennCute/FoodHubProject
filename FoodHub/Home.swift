//
//  Home.swift
//  FoodHub
//
//  Created by OPSolutions on 2/8/22.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mealCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mealsList: [MealsData] = []
    var dataFromApi:[String] = []
    var mealIDs:[String] = []
    var dataFromApiMeals:[String] = []
    var dataFromApiMealsImage:[String] = []
    var categoryList: [Categories] = []
    let userID = UserDefaults.standard.string(forKey: Constants().userIdKey)
    let loginEmail = UserDefaults.standard.string(forKey: Constants().loginEmailKey)
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print ("This is the count \(dataFromApi.count)")
//        return dataFromApi.count
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        as! MyCollectionVCell
//
//        cell.myWebSeriesLabel.text = dataFromApi[indexPath.row]
//        cell.myWebSeriesLabel.layer.cornerRadius = 50.0
//
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if(collectionView == mealCollectionView){
            return dataFromApiMeals.count
        }
        return dataFromApi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if(collectionView == mealCollectionView){

        let cellMeal = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
        as! MealCollectionViewCell
            let meals = mealsList[indexPath.row]
            if let url = URL(string: meals.strMealThumb ) {
                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    cellMeal.mealImageView.image = UIImage(data: data)
                                }
                            }//task
                            task.resume()
                        }//if-else

        cellMeal.titleLabel.text = meals.strMeal
        cellMeal.titleLabel.layer.cornerRadius = 50.0
        return cellMeal
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        as! MyCollectionVCell
//        let url = URL(string: self.mealImage[indexPath.row])

//        let mealImage = UIImageView().loadImageFromURL(url: url!)
        cell.myWebSeriesLabel.text = dataFromApi[indexPath.row]
        cell.myWebSeriesLabel.layer.cornerRadius = 50.0
        return cell
    }
    
    
//    let url = "https://www.themealdb.com/api/json/v1/1/categories.php"
    var webSeriesImages:[String] = ["mmask", "mpants", "mwallet"]
    
    override func viewDidLoad() {

        print("This is your userID !! \(userID ?? "")")
        print("This is your Email !! \(loginEmail ?? "")")
        getJson()
        getCategory()
        mealCollectionView.collectionViewLayout = UICollectionViewFlowLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        mealCollectionView.reloadData()
    }
    
    func getCategory(){
        
        AF.request("https://www.themealdb.com/api/json/v1/1/categories.php").responseString(completionHandler: { response in
            switch response.result {
            case .success(let value):
                //end loading..
//                print("value**: \(value)")
                do {
                    let data = try value.data(using: .utf8)!
//                    print("data \(data)")
                    let decoder = JSONDecoder()
                    guard let categoryListData = try? decoder.decode(CategoryList.self, from: data) else {
                        print ("Jason Failed")
                        return }
                        self.categoryList = categoryListData.categories
                        self.setupCell()
                        
                } catch {
                    // handle error
                    print("error")
                }
            case .failure(let error):
                //end loading..
                print(error)
                let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func getJson() {

          let urlString = ("https://www.themealdb.com/api/json/v1/1/filter.php?c=Beef")
          if let url = URL(string: urlString) {
          URLSession.shared.dataTask(with: url) {data, res, err in
            do {
                let decoder = JSONDecoder()
                let apiData = try decoder.decode(MealsList.self, from: data!)

                self.mealsList = apiData.meals
                self.setupCellMeals()

                }catch{

                    print(err as Any)

              }//do-catch
            }.resume()
        }
    }
    
}

extension Home {

    func setupCell(){
        let count = categoryList.count
        for i in 0...(count-1){
            let sampleID = categoryList[i] as Categories
            dataFromApi.append(sampleID.strCategory)
        }
//        print("This is the id's \(dataFromApi)")
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupCellMeals(){
        let countMeals = mealsList.count
        for i in 0...(countMeals-1){
            let sampleIDMeals = mealsList[i] as MealsData
            dataFromApiMeals.append(sampleIDMeals.strMeal)
//            dataFromApiMealsImage.append(sampleIDMeals.strMealThumb)
        }
        
        DispatchQueue.main.async {
            print("Testing ito yung beef")
            self.mealCollectionView.reloadData()
        }
    }
    
}
extension UIImageView {

    func loadImageFromURL(url: URL) -> UIImage{

        var returnImage = UIImage()

        if let data = try? Data(contentsOf: url){

            returnImage = UIImage(data: data)!

        }

        return returnImage

    }
}
extension Home:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: 190, height: 272)
    }
}

