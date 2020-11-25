:- register_ros_package(knowrob).
:- register_ros_package(rosprolog).

:- rdf_db:rdf_register_ns(urdf, 'http://knowrob.org/kb/urdf.owl#', [keep(true)]).
:- owl_parser:owl_parse('package://knowrob/src/ros/urdfprolog/owl/urdf.owl').

:- use_module('rdf_urdf').
