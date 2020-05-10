//
//  ContentView.swift
//  Bullseye
//
//  Created by Kairzhan Kural on 5/5/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.white)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .modifier(Shadow())
        }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .font(Font.custom("Arial Rounded MT bold", size: 24))
                .modifier(Shadow())
        }
    }
    
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("Arial Rounded MT bold", size: 18))
                .foregroundColor(Color.black)
        }
    }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .font(Font.custom("Arial Rounded MT bold", size: 12))
                .foregroundColor(Color.black)
        }
    }
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
    
    var body: some View {
        VStack {
            Spacer()
            //Target row
            HStack {
                Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                Text("\(target)").modifier(ValueStyle())
            }
            
            Spacer()
            //Slider row
            HStack {
                Text("1").modifier(LabelStyle())
                Slider(value: $sliderValue, in: 1...100).accentColor(Color.green
                )
                Text("100").modifier(LabelStyle())
            }
            
            Spacer()
            //Button row
            Button(action: {
                self.alertIsVisible = true
            }) {
                Text(/*@START_MENU_TOKEN@*/"Hit me!"/*@END_MENU_TOKEN@*/)
            }
            .alert(isPresented: $alertIsVisible) { () ->Alert in
                return Alert(title: Text(alertTitle()),
                             message: Text(
                                "The slider's value is \(sliderValueRounded()).\n" +
                                "You scored \(pointsForCurrentRound()) points this round"),
                             dismissButton: .default(Text("Awesome")) {
                                self.score = self.score + self.pointsForCurrentRound()
                                self.target = Int.random(in: 1...100)
                                self.round += 1
                    })
            }
            .background(Image("Button"))
            .modifier(ButtonLargeTextStyle())
            Spacer()
            
            //Score row
            HStack {
                Button(action: {
                    self.startNewGame()
                }) {
                    HStack {
                    Image("StartOverIcon")
                    Text("Start over")
                    }
                }
                .background(Image("Button"))
                .modifier(ButtonSmallTextStyle())
                Spacer()
                Text("Score:").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                Text("Round:").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                NavigationLink(destination: AboutView()) {
                    HStack {
                    Image("InfoIcon")
                    Text("Info")
                    }
                }
                .background(Image("Button"))
                .modifier(ButtonSmallTextStyle())
            }
            .padding(.bottom, 20)
            
        }
        .background(Image("Background"), alignment: .center)
        .accentColor(midnightBlue)
        .navigationBarTitle("Bullseye")
    }
    
    func sliderValueRounded() -> Int {
        Int(sliderValue.rounded())
    }
    
    func amountOff() -> Int {
        abs(target - sliderValueRounded())
    }
    
    func pointsForCurrentRound() -> Int {
        let maxScore = 100
        let difference = amountOff()
        let bonus: Int
        if difference == 0 {
            bonus = 100
        } else if difference == 1 {
            bonus = 50
        } else {
            bonus = 0
        }
        return maxScore - difference + bonus
    }
    
    func alertTitle() -> String {
        let difference = amountOff()
        let title: String
        if difference == 0 {
            title = "Perfect!"
        } else if difference < 5 {
            title = "You almost had it!"
        } else if difference < 10 {
            title = "Not bad!"
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    func startNewGame() {
        score = 0
        round = 1
        target = Int.random(in: 1...100)
        sliderValue = 50.0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
