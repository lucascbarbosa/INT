import pygmsh

with pygmsh.occ.Geometry() as geom:
    lcar = 0.00001
    p1 = geom.add_point([0.00000, 0.00000], lcar)
    p2 = geom.add_point([0.00005, 0.00000], lcar)
    p3 = geom.add_point([.0001, 0.00000], lcar)
    p4 = geom.add_point([.0001, 0.00005], lcar)
    p5 = geom.add_point([.0001, .0001], lcar)
    p6 = geom.add_point([0.00005, .0001], lcar)
    p7 = geom.add_point([0.00000, .0001], lcar)
    p8 = geom.add_point([0.00000, 0.00005], lcar)

    # s1 = geom.add_bspline([p1, p2, p3, p4, p5, p6, p7, p8, p1])
    s1 = geom.add_bspline([p2, p3, p4, p5, p6, p7, p8, p1, p2])

    ll = geom.add_curve_loop([s1])
    
    pl = geom.add_plane_surface(ll)

    mesh = geom.generate_mesh()
    mesh.write('test2.vtk')