// Licence: GNU General Public License version 2 (GPLv2)
// Gas cylinder holder for mounting on Thorlabs breadboards
$fn = 60;

// for sigma aldrich https://www.sigmaaldrich.com/catalog/product/aldrich/y906581?lang=en&region=US
vial_diameter   = 2*25.4+1; // PLA
// SCOTTY 14
//vial_diameter   = 76.8+1; // PLA

flange_diameter = 150;
flange_height   = 180;
wall_thickness  = 5;
base = 0;
base_x = 175;
base_y = 175;
base_z = 12.7;
hole_pitch = 1*(25.4+0.15); // PLA
hole_d = 7; // PLA

vial_radius = vial_diameter / 2;
flange_radius = flange_diameter / 2;

union(){
    
    difference(){
        thorlabs_base();
        translate([base_x,base_y, 0]/2){
            rotate([0,180,180]){
                linear_extrude(2)
                text("© 2018 Matthias H. Richter", size = 10, halign = "center", valign = "center"); 
            }
        }
    }
    translate([(base_x)/2,(base_y)/2,base_z]){
    //base_holer();
    base_holer2();
    }
}


module thorlabs_base(){
    difference(){
        minkowski() {
            cube([base_x,base_y,base_z],false);
            sphere(r = 2);
        }
        {
        translate([(base_x-hole_pitch*6)/2,(base_y-hole_pitch*6)/2,-1]){
        cylinder(r=hole_d /2, h=base_z*2);
        }
        translate([(base_x-hole_pitch*6)/2,(base_y-hole_pitch*6)/2+(hole_pitch*6),-1]){
        cylinder(r=hole_d /2, h=base_z*2);
        }
        translate([(base_x-hole_pitch*6)/2+(hole_pitch*6),(base_y-hole_pitch*6)/2,-1]){
        cylinder(r=hole_d /2, h=base_z*2);
        }
        translate([(base_x-hole_pitch*6)/2+(hole_pitch*6),(base_y-hole_pitch*6)/2+(hole_pitch*6),-1]){
        cylinder(r=hole_d /2, h=base_z*2);
        }
    }
    }
}


module base_holer2(){
    rotate_extrude() {
        difference() {
            square(size=[flange_radius, flange_height+base]);
            union() {
                translate([flange_radius, flange_height+base])
                scale([(flange_radius-vial_radius-wall_thickness)/flange_height,1])circle(r=flange_height);
                translate([0,base]) square(size=[vial_radius, flange_height]);
            };
      }
    }
}


module base_holer(){
    rotate_extrude() {
        difference() {
            square(size=[flange_radius, flange_height+base]);
            union() {
                translate([wall_thickness + vial_radius + flange_height, flange_height+base])
                    circle(r=flange_height);
                translate([0,base]) square(size=[vial_radius, flange_height]);
            };
        }
    }
}
