//
//  File.swift
//  Orbit
//
//  Created by Garv Shah on 23/4/2022.
//

import Foundation
import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 20)
            
            Text("Button Guide")
                .font(.title)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "play").foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.accentColor))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Text("This is the play/pause button. It starts and stops the simulation and the movement of the bodies, allowing for them to be seen at a particular point in time")
                }
                .padding(20)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "gear").foregroundColor(.white)
                            .imageScale(.large)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.accentColor))
                        
                        Spacer()
                            .frame(width: 30)
                        
                        VStack {
                            Text("This is the settings button. This will display a menu where you can select various settings about the scene. This includes:")
                        }
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 30)
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(height: 40)
                            
                            Text("\u{2022} Focusing on a particular body, which subtracts its movements from all bodies in the scene to keep everything from its point of view. For example, focusing on the Earth would give us the view of the Solar System astronomers thought to be correct a few centuries back (with the Earth as the centre of the universe), while focusing on the sun would give us the view of the Solar System commonly taught in classrooms")
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                            
                            Text("\u{2022} Showing the trails of bodies over time as they move through space")
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                            
                            Text("\u{2022} Showing velocity arrows to indicate the current velocity of bodies")
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                            
                            Text("\u{2022} Modifying the gravitational constant. The gravitational constant is a value in the formula, which is normally quite a small number, causing the force to be quite weak. For visualisation purposes, this is increased to 1 by default so that the bodies can be a lot smaller and closer together and gravity is stronger for demonstration purposes. This value can be changed to better reflect reality or played with to see how it influences the rule.")
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider()
                            
                            Text("\u{2022} Restarting the scene to its initial state")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                            .frame(width: 30)
                    }
                    
                }
                .padding(20)
                
                HStack {
                    Image(systemName: "plus").foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.accentColor))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Text("Shows additional menu options on the side")
                }
                .padding(20)
                
                HStack {
                    Image(systemName: "pencil").foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.accentColor))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Text("This is the edit scene button, which allows you to edit the properities of bodies as well as add/delete them. As such, you can edit the velocity, position, colour, name, etc of the bodies and modify the scene as you wish")
                }
                .padding(20)
                
                HStack {
                    Image(systemName: "trash").foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.accentColor))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Text("This is the delete all button, and clears all bodies from the current scene")
                }
                .padding(20)
                
                HStack {
                    Image(systemName: "shuffle").foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.accentColor))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Text("This is the random button. It creates a various amount of random bodies within the specified ranges. By default, it will create 3 - 9 bodies with various random properties as specified in the bounds available")
                }
                .padding(20)
                
                HStack {
                    Image(systemName: "cube.transparent").foregroundColor(.white)
                        .imageScale(.large)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.accentColor))
                    
                    Spacer()
                        .frame(width: 30)
                    
                    Text("This is the AR button. This moves you to an AR scene, which allows you to experience the movement of the bodies in augmented reality as if they were there with you in the room")
                }
                .padding(20)
            }
            
            Text("By Garv Shah for their Swift Student Challenge 2022 Submission")
                .multilineTextAlignment(.center)
        }
    }
}
