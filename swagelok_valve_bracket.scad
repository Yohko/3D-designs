// Licence: GNU General Public License version 2 (GPLv2)
$fn = 60;

base = 7;
d_arc = 15;
height = 30;
copies = 1;

// Paramewters for valve
d_valve = 11;
// inset is necessary for e.g. needle valves
inset = 1; // 1 .. yes; 0 .. no
h_inset = base-2.5;
d_inset = 23.5;


for(i=[0:copies-1]){
    translate([0, 2*(d_arc/2+10)*i,0]) {
        holder();
    }
}


module holder()
{
    difference() {
        cube([7, 2*(d_arc/2+10), base+20]);
        translate([-1, 10, base+10]) {
            rotate(a = [0,90,0]) {
                cylinder(r=2, h=base+2);
            }
        }
        translate([-1, 2*(d_arc/2+10)-10, base+10]) {
            rotate(a = [0,90,0]) {
                cylinder(r=2, h=base+2);
            }
        }
    }
    difference() {
        union(){
            cube([base+height/2, 2*(d_arc/2+10), base]);
            translate([base+height/2, (d_arc/2+10), 0]) {
                cylinder(r=d_arc/2+10, h=base);
            }
        }
        translate([base+height/2, (d_arc/2+10), -1]) {
            cylinder(r=d_valve/2, h=base+2);
        }
        if(inset==1){
            translate([base+height/2, (d_arc/2+10), base-h_inset]){
                cylinder(r=d_inset/2, h=h_inset+1);
            }
        }
    }
}
