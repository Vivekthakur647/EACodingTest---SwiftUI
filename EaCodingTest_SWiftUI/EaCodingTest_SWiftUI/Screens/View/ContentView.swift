//
//  ContentView.swift
//  EaCodingTest_SWiftUI
//
//  Created by VIVEK THAKUR on 07/04/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.allRecords) { record in
                    Section(header: Text(record.recordName ?? "").font(.headline)) {
                        ForEach(record.allBands ?? [String](), id: \.self) { band in
                            Text(band)
                            let joined = record.allFestivals!.joined(separator: "\n")
                            Text(joined).padding(.leading, 30).italic().foregroundColor(.gray)
                        }
                    }
                }
            }.animation(.easeInOut, value: UUID())
                .listStyle(.sidebar).task { await viewModel.loadData() }
            .navigationTitle("EA coding test")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {  await viewModel.loadData() }
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
        }.alert("Data is not in correct format", isPresented: $viewModel.showingAlert) {
            Button("Please Refresh") { Task {  await viewModel.loadData() } }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
