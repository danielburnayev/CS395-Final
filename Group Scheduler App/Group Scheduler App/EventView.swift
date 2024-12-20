//
//  EventView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/3/24.
//

import Foundation
import SwiftUI

struct EventView: View {
    
    @State var eventColor: Color
    @State var startTime: String
    @State var endTime: String
    @State var eventStartDate: Date
    @State var eventEndDate: Date
    @State var eventDescription: String
    @Binding var twelveHourTime: Bool
    @State private var height: CGFloat = 0.0
    
    var body : some View {
        VStack {
            Text("\(startTime)\n\(endTime)")
                .padding(EdgeInsets(top: 7.5, leading: 0, bottom: 5, trailing: 0))
            Text("\(eventDescription)")
                .bold()
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 7.5, trailing: 0))
        }
        .frame(minWidth: 1,
               maxWidth: 393,
               minHeight: 1,
               maxHeight: height,
               alignment: .topLeading)
        .background(eventColor)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0.5)
        .onAppear() {
            height = eventHeight()
            
            if (twelveHourTime && !startTime.contains(":")) {twentyFourHourTo12Hour()}
            else if (!twelveHourTime && startTime.contains(":")) {twelveHourTo24Hour()}
        }
        .onChange(of: twelveHourTime) {
            height = eventHeight()
            
            if (!twelveHourTime) {twelveHourTo24Hour()}
            else {twentyFourHourTo12Hour()}
        }
    }
    
    func twelveHourTo24Hour() {
        let startTimeArr = startTime.split(separator: ":")
        let endTimeArr = endTime.split(separator: ":")
        
        startTime = ""
        endTime = ""
        
        let startFirst = Int(startTimeArr[0])!
        let startSecond = Int(startTimeArr[1].prefix(2))!
        let startAmOrPm = startTimeArr[1].suffix(2)
        
        let first = ((startFirst == 12) ? startFirst - 12 : startFirst) * 100 + ((startAmOrPm == "am") ? 0 : 12) * 100 + startSecond
        if (first < 1000) {startTime += "0"}
        startTime += String(first)
        if (first == 0) {startTime += "00"}
        
        let endFirst = Int(endTimeArr[0])!
        let endSecond = Int(endTimeArr[1].prefix(2))!
        let endAmOrPm = endTimeArr[1].suffix(2)
        
        let end = ((endFirst == 12) ? endFirst - 12 : endFirst) * 100 + ((endAmOrPm == "am") ? 0 : 12) * 100 + endSecond
        if (end < 1000) {endTime += "0"}
        endTime += String(end)
        if (end == 0) {endTime = "2400"}
    }
    
    func twentyFourHourTo12Hour() {
        var startAmPm = true
        var startFirst = Int(startTime.prefix(2))!
        let startSecond = Int(startTime.suffix(2))!
        
        if (startFirst > 12) {
            startAmPm = (startFirst == 24) ? true : false
            startFirst -= 12
        }
        else if (startFirst == 12) {startAmPm = false}
        else if (startFirst == 0) {startFirst += 12}
        startTime = String(startFirst) + ":" + ((startSecond < 10) ? "0" : "") + String(startSecond) + ((startAmPm) ? "am" : "pm")
        
        var endAmPm = true
        var endFirst = Int(endTime.prefix(2))!
        let endSecond = Int(endTime.suffix(2))!
        
        if (endFirst > 12) {
            endAmPm = (endFirst == 24) ? true : false
            endFirst -= 12
        }
        else if (endFirst == 12) {endAmPm = false}
        else if (endFirst == 0) {endFirst += 12}
        endTime = String(endFirst) + ":" + ((endSecond < 10) ? "0" : "") + String(endSecond) + ((endAmPm) ? "am" : "pm")
    }
    
    private func eventHeight() -> CGFloat {
        let startHour = Date.getHourNum(date: eventStartDate)
        let startMin = Date.getMinuteNum(date: eventStartDate)
        let startValue = CGFloat(startHour * ((twelveHourTime) ? 115 : 125)) + (CGFloat(integerLiteral: startMin) / 60) * ((twelveHourTime) ? 115 : 125)
        
        let endHour = Date.getHourNum(date: eventEndDate)
        let endMin = Date.getMinuteNum(date: eventEndDate)
        let endValue = CGFloat(endHour * ((twelveHourTime) ? 115 : 125)) + (CGFloat(integerLiteral: endMin) / 60) * ((twelveHourTime) ? 115 : 125)
        
        return endValue - startValue
    }
}

//#Preview {
//    EventView(eventColor: .yellow, 
//              startTime: "3:00pm", endTime: "6:00pm",
//              eventStartDate: Date(),
//              eventDescription: "Event 1")
//}
