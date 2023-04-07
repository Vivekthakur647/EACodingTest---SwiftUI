//
//  ContentView-ViewModel.swift
//  EaCodingTest_SWiftUI
//
//  Created by VIVEK THAKUR on 07/04/23.
//

import Foundation
extension ContentView {
    @MainActor class ViewModel : ObservableObject {
        @Published private(set) var allRecords = [AllRecordsModel]()
        @Published var showingAlert = false
        func loadData() async {
            guard let url = URL(string: EndPoints.festivalList.url) else { return  }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let nonFormatedDict = object as? [[String: AnyObject]] {
                        let formatedDict = self.processedRecordsHierarchy(nonFormatedDict: nonFormatedDict)
                        self.decode(modelType: [AllRecordsModel].self, fromObject: formatedDict) { records in
                            self.allRecords = records
                        }
                    }
                } catch {
                    showingAlert = true
                }
            } catch {
                showingAlert = true
            }
        }
        func decode<T>(modelType: T.Type, fromObject: Any, _ genericModel: @escaping (T) -> Void) where T: Decodable {
            do {
                let socketForHostData = try JSONSerialization.data(withJSONObject: fromObject)
                do {
                    let finalModel = try JSONDecoder().decode(modelType, from: socketForHostData)
                    genericModel(finalModel)
                } catch let err {
                    print(err)
                }
            } catch _ { }
        }
        // MARK: To fetch all sorted records
        func processedRecordsHierarchy (nonFormatedDict :[[String: AnyObject]]) -> [[String: Any]] {
            var processedDict = [[String: Any]]()
            var recordArray = [String]()
            recordArray = self.fetchAllRecords(dict: nonFormatedDict)
            recordArray.forEach { singleRecord in
                var singleRecordBand = [String]()
                var singleRecordFests = [String]()
                for item in nonFormatedDict {
                    if let unFormatedbands = item["bands"] as? [[String : Any]]  {
                        for mainband in unFormatedbands {
                            if let recodLable = mainband["recordLabel"] as? String  {
                                let modifiedRecordName = recodLable == "" ? "Record name missing" : recodLable
                                if modifiedRecordName == singleRecord {
                                    if let bandName = mainband["name"] as? String , !singleRecordBand.contains(bandName) {
                                        singleRecordBand.append(bandName)
                                    }
                                    if let bandsFestName = item["name"] as? String , !singleRecordFests.contains(bandsFestName) {
                                        singleRecordFests.append(bandsFestName)
                                    }
                                }
                            }
                        }
                    }
                }
                var processedObj = [String : Any]()
                processedObj["recordName"] = singleRecord
                processedObj["allBands"] = singleRecordBand.sorted()
                processedObj["allFestivals"] = singleRecordFests.sorted()
                processedDict.append(processedObj)
            }
            return processedDict
        }
        // MARK: To fetch all sorted records
        func fetchAllRecords (dict :[[String: AnyObject]]) -> [String]{
            var recordArray = [String]()
            dict.forEach { unformattedDictObj in
                guard let unFormatedbands = unformattedDictObj["bands"] as? [[String : Any]] else { return }
                unFormatedbands.forEach { unFormatedbandObj in
                    if let recordLable = unFormatedbandObj["recordLabel"] as? String {
                        let modifiedRecordName = recordLable == "" ? "Record name missing" : recordLable
                        if !recordArray.contains(modifiedRecordName) {
                            recordArray.append(modifiedRecordName)
                        }
                    }
                }
            }
            return recordArray.sorted()
        }
    }
}
