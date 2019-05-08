//
//  ProjectSummaryViewController.swift
//  ProjectPlanner
//
//  Created by user153198 on 4/28/19.
//  Copyright © 2019 Arnold Anthonypillai. All rights reserved.
//

import UIKit

class ProjectSummaryViewController: UIViewController
{
    let helper = Helper()
    var project: Project?
    
//    var projectName: String?
//    var projectNotes: String?
//    var projectPriority: String?
//    var projectDueDate: Date?
//    var projectAddToCalendar: Bool?
    
    @IBOutlet weak var progressBar_daysRemaining: CircularProgressBar!
    @IBOutlet weak var progressBar_percentage: CircularProgressBar!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var txtView_notes: UITextView!
    @IBOutlet weak var label_addedToCalendar: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(project != nil)
        {
            self.txtView_notes.layer.borderColor = UIColor.lightGray.cgColor
            self.txtView_notes.layer.borderWidth = 1
            self.txtView_notes.isEditable = false
            
            let addedToCalendar = "Added to calendar: \(helper.unwrapBoolean(optionalBool: project?.addToCalendar) ? "Yes" : "No")"
            let notes = helper.unwrapBoolean(optionalBool: project?.notes?.isEmpty) ? "No notes available!" : helper.unwrapString(optionalString: project?.notes)
            label_title.text = "\(helper.unwrapString(optionalString: project?.name)) - \(helper.unwrapString(optionalString: project?.priority)) Priority"
            txtView_notes.text = notes
            label_addedToCalendar.text = addedToCalendar
            
            progressBar_percentage.labelSize = 20
            progressBar_percentage.safePercent = 100
            progressBar_percentage.setProgress(to: 45, withAnimation: true)
            progressBar_percentage.lineWidth = 20
            
            progressBar_daysRemaining.labelSize = 20
            progressBar_daysRemaining.safePercent = 100
            progressBar_daysRemaining.setProgress(to: 20, withAnimation: true)
            progressBar_daysRemaining.lineWidth = 20
        }
        
        else
        {
            label_title.text = nil
            txtView_notes.text = nil
            label_addedToCalendar.text = nil
            progressBar_percentage.hideView()
            progressBar_daysRemaining.hideView()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //
        if segue.identifier == "editProject"
        {
            if(project == nil)
            {
                let alertController = UIAlertController(title: "Alert", message: "Please select a project to proceed!", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                {
                    (action:UIAlertAction) in
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            else
            {
                if let add_edit = segue.destination as? Add_Edit_ProjectViewController
                {
                    add_edit.project = project
                }
            }
        }
        
        //        if segue.identifier == "addAlbum"
        //        {
        //            if let addAlbumViewController = segue.destination as? AddAlbumViewController{
        //                addAlbumViewController.currentArtist = artist
        //            }
        //        }
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
