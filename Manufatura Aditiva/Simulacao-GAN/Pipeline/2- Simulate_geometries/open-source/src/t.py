import pygmsh

with pygmsh.occ.Geometry() as geom:
    lcar = 0.1
    p1 = geom.add_point([0.0, 0.0], lcar)
    p2 = geom.add_point([0.5, 0.0], lcar)
    p3 = geom.add_point([1.0, 0.0], lcar)
    p4 = geom.add_point([1.0, 0.5], lcar)
    p5 = geom.add_point([1.0, 1.0], lcar)
    p6 = geom.add_point([0.5, 1.0], lcar)
    p7 = geom.add_point([0.0, 1.0], lcar)
    p8 = geom.add_point([0.0, 0.5], lcar)

    s1 = geom.add_bspline([p1, p2, p3, p4, p5, p6, p7, p8, p1])

    ll = geom.add_curve_loop([s1])
    
    pl = geom.add_plane_surface(ll)

    mesh = geom.generate_mesh()
    mesh.write('test2.vtk')