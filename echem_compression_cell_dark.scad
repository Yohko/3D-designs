// Licence: GNU General Public License version 2 (GPLv2)
$fn = 60;
inch = 25.4; // for unit conversion 


// ------------- Cell parameters ------------
height = 2.1;
width = 2;
d_screws = 4/25.4;
d_0p25_28 = 0.2;  // 1/4''-28, thread needs to be tapped later
d_0p125_NTP = 0.3;//0.41 // 1/8'' NPT, thread needs to be tapped later
// small o-ring (015): https://www.mcmaster.com/9319K15
O_015_ID = 0.551;
O_015_OD = 2*0.354;//0.7;//0.691;
O_015_ODsq = 0.559607913;
O_015_W = 0.085;//0.07;
O_015_H = 0.052;//0.052; // depth of groove
// big o-ring (019): https://www.mcmaster.com/9319K142
O_019_ID = 0.801;
O_019_OD = 2*0.336;//0.941; // will be stretched in the drawing
O_019_ODsq = 0.755957454;
O_019_W = 0.085;
O_019_H = 0.052;
// ------------------------------------------


// create pieces
translate([0,0,0.5*inch])rotate([-90,0,0]){
translate([2.5*inch,0.25*inch,2.5*inch])back_plate(0.25);
translate([0*inch,0.25*inch,2.5*inch])front_plate(0.25);
CE_plate(0.5);
translate([2.5*inch,0,0])WE_plate(0.5);
}


module WE_plate(d){
    difference(){
        base_WECE(d);
        
        // port for reference electrode
        r1 = 2.5/25.4/2;
        offset1 = 0.887+0.444/2+sin(30)*r1+0.01;
        translate([(width/2+tan(30)*offset1)*inch,d/2*inch,(0.887+0.444/2-offset1)*inch])rotate([0,-30,0])cylinder(r=r1*inch, h=1.1*inch+1);

        r2 = 0.313/2;
        offset2 = 0.887+0.444/2+sin(30)*r2+0.01;
        translate([(width/2+tan(30)*offset2)*inch,d/2*inch,(0.887+0.444/2-offset2)*inch])rotate([0,-30,0])cylinder(r=r2*inch, h=0.17*inch+1);

        r3 = d_0p25_28/2;
        offset3 = 0.887+0.444/2+sin(30)*r3+0.01;
    translate([(width/2+tan(30)*offset3)*inch,d/2*inch,(0.887+0.444/2-offset3)*inch])rotate([0,-30,0])   cylinder(r=r3*inch, h=(0.25+0.18)*inch+1);
    }
}


module CE_plate(d){
    base_WECE(d);
}


module front_plate(d){
    // has a hole if illumination is needed
    difference(){
        base(d);
        rotate([-90,0,0])translate([width/2*inch,-(0.887)*inch,d/2*inch])cylinder(r=0.444/2*inch, h=d*inch+2,center = true);
    }
}


module back_plate(d){
    base(d); 
}


module base(d){
    // will be also used as a template for all other pieces
    difference(){
        cube(size = [width*inch,d*inch,height*inch], center = false);
        // screw holes
        rotate([-90,0,0])translate([0.315*inch,-0.415*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(width-0.315)*inch,-0.415*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([0.315*inch,-(1.37+0.415)*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
        rotate([-90,0,0])translate([(width-0.315)*inch,-(1.37+0.415)*inch,-1])cylinder(r=d_screws/2*inch, h=d*inch+2);
    }
}


module base_WECE(d){
        difference(){
        base(d);
        // electrolyte compartment
        hull(){
            rotate([-90,0,0])translate([width/2*inch,-(0.887+0.482)*inch,-1])cylinder(r=0.444/2*inch, h=0.32*inch+1,center = false);
            rotate([-90,0,0])translate([width/2*inch,-(0.887)*inch,-1])cylinder(r=0.444/2*inch, h=0.32*inch+1,center = false);
        }
        // through hole for WECE
        rotate([-90,0,0])translate([width/2*inch,-(0.887)*inch,-1])cylinder(r=0.444/2*inch, h=d*inch+2,center = false);
        // the tilted inset for better bubble removal
        translate([width/2*inch,0,1.2*inch])rotate([50,0,0])cylinder(r=0.219*inch, h=2*d*inch,center = true);
        // o-ring groove for membrane
        difference(){
            hull(){
                rotate([-90,0,0])translate([(1)*inch,-0.887*inch,-1])cylinder(d=O_019_OD*inch,h=O_019_H*inch+1);
                rotate([-90,0,0])translate([(1)*inch,-(0.887+0.482)*inch,-1])cylinder(d=O_019_OD*inch,h=O_019_H*inch+1);
            }
            hull(){
                rotate([-90,0,0])translate([(1)*inch,-0.887*inch,-1])cylinder(d=(O_019_OD-2*O_019_W)*inch,h=O_019_H*inch+1);
                rotate([-90,0,0])translate([(1)*inch,-(0.887+0.482)*inch,-1])cylinder(d=(O_019_OD-2*O_019_W)*inch,h=O_019_H*inch+1);
            }
        }
        // o-ring groove for WE/CE
        rotate([-90,0,0])translate([(1)*inch,-0.887*inch,(d-O_015_H)*inch])hollowCylinder(O_015_OD*inch,O_015_H*inch+1,O_015_W*inch); // o-ring groove        
        
        // middle gas exhaust
        rotate([0,0,0])translate([1*inch,d/2*inch,(height-0.54)*inch])cylinder(r=0.067/2*inch, h=1*inch+1); 
        rotate([0,0,0])translate([1*inch,d/2*inch,(height-0.425)*inch])cylinder(r=d_0p25_28/2*inch, h=0.425*inch+1);    // 1/4''-28 
        translate([width/2*inch,d*inch/2,(0.887+0.482+0.222+0.04)*inch])cylinder(h=0.1*inch, r1=1*0.067*inch, r2=0.067/2*inch, center=true);

        // left & right gas exhaust
        r1 = 0.1285/2;
        offset1 = height-0.887-0.444/2+sin(30)*r1+0.01;
        translate([(width/2+tan(30)*offset1)*inch,d/2*inch,(0.887+0.444/2+offset1)*inch])rotate([0,30+180,0])cylinder(r=r1*inch, h=1.1*inch+1);
        translate([(width/2-tan(30)*offset1)*inch,d/2*inch,(0.887+0.444/2+offset1)*inch])rotate([0,-30-180,0])cylinder(r=r1*inch, h=1.1*inch+1);

        r2 = 0.313/2;
        offset2 = height-0.887-0.444/2+sin(30)*r2+0.01;
        translate([(width/2+tan(30)*offset2)*inch,d/2*inch,(0.887+0.444/2+offset2)*inch])rotate([0,30+180,0])cylinder(r=r2*inch, h=0.17*inch+1);
        translate([(width/2-tan(30)*offset2)*inch,d/2*inch,(0.887+0.444/2+offset2)*inch])rotate([0,-30-180,0])cylinder(r=r2*inch, h=0.17*inch+1);

        r3 = d_0p25_28/2;
        offset3 = height-0.887-0.444/2+sin(30)*r3+0.01;
        translate([(width/2+tan(30)*offset3)*inch,d/2*inch,(0.887+0.444/2+offset3)*inch])rotate([0,30+180,0])   cylinder(r=r3*inch, h=(0.25+0.18)*inch+1);
        translate([(width/2-tan(30)*offset3)*inch,d/2*inch,(0.887+0.444/2+offset3)*inch])rotate([0,-30-180,0])  cylinder(r=r3*inch, h=(0.25+0.18)*inch+1);
        
        // bottom gas inlet
        //rotate([0,0,0])translate([1*inch,d/2*inch,-1])cylinder(r=0.33/2*inch, h=(1.55+0.26)*inch+1);
        rotate([0,0,0])translate([1*inch,d/2*inch,-1])cylinder(r=d_0p125_NTP/2*inch, h=(0.800)*inch+1); // 1/8'' NPT
    }
}


module hollowCylinder(d, h, wallWidth)
{
	difference()
	{
		cylinder(d=d, h=h);
		translate([0, 0, -0.1])cylinder(d=d-(wallWidth*2), h=h+0.2);
	}
}
