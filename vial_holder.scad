// Licence: GNU General Public License version 2 (GPLv2)
$fn = 60;


// big 20ml vials
/*
d_vial = 28.3; //27.5
h_hole = 26;
gap = 2.5;
num_x = 4;
num_y = 5;
*/

// Thermo Fisher 2ml HPLC screw cap viasls
d_vial = 12.8; // 12.5 when printed in PLA
h_hole = 16;
gap = 2;
num_x = 15;
num_y = 10;

text_size = 4;
text_height = 4;

t_bottom = 4;
height = h_hole+t_bottom;

union(){
    difference(){
        Tray();
        translate([num_x*(gap+d_vial)+gap,num_y*(gap+d_vial)+gap, 0]/2){
            rotate([0,180,180]){
                linear_extrude(2)
                text("© 2018 Matthias H. Richter", size = 12, halign = "center", valign = "center"); 
            }
        }
    }
    // add row letters and column numbers
    for (x=[1:num_x]){
        addtext(num_x-x+1,0.5-0.85/d_vial, str(x));
    }
    for (y=[1:num_y]){
        addtext(num_x+0.5+0.9/d_vial,y, chr(64+y)); // 65 is A
    }
}


module Tray() {
    difference(){
        // box
        minkowski(){
            //cube([num_x*(gap+d_vial)+gap, num_y*(gap+d_vial)+gap, height]);
            roundCornersCube(num_x*(gap+d_vial)+gap, num_y*(gap+d_vial)+gap, height,5);
            sphere(r = 2);
        }
        // holes for vials
        for (x=[1:num_x], y=[1:num_y]){
            translate([(d_vial*x)+(gap*x)-d_vial/2,(d_vial*y)+(gap*y)-d_vial/2,t_bottom])
            cylinder(r=d_vial/2, h=height);    
        }  
    }
}


module roundCornersCube(x,y,z,r){
    hull(){
        translate([x-r,y-r,z/2])cylinder(z,r=r,center=true);
        translate([r,y-r,z/2])cylinder(z,r=r,center=true);
        translate([x-r,+r,z/2])cylinder(z,r=r,center=true);
        translate([r,r,z/2])cylinder(z,r=r,center=true);
    }
}


module addtext(x,y, s){
       translate([(d_vial*x)+(gap*x)-d_vial/2,(d_vial*y)+(gap*y)-d_vial/2,height-1])rotate([0,0,180]){
        linear_extrude(text_height)text(s, size = text_size, halign = "center", valign = "center"); 
       }
}
