/*
  Copyright (C) 2015 Daniel Beßler
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
      * Neither the name of the <organization> nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

:- module(knowrob_vis,
    [
      show/1,
      show/2,
      show_next/0
    ]).
/** <module> Methods for visualizing parts of the knowledge base

  @author Daniel Beßler
  @license BSD
*/
:- use_module(library('semweb/rdfs')).
:- use_module(library('semweb/rdf_db')).
:- use_module(library('jpl')).
:- use_module(library('knowrob/computable')).
%:- use_module(library('knowrob/marker_vis')).
:- use_module(library('knowrob/data_vis')).

:- rdf_meta 
      show(t),
      show(t,t).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % Convinience predicate for different types of visualizations

%% show(+VisualThing) is det.
%% show(+VisualThing, +Instant) is det.
%% show(+VisualThing, +Instant, +Properties) is det.
%
% VisualThing is a thing with a visual interpretation
% and some way to generate a ROS visualization message for it.
% This includes marker_visualization messages and data_vis messages.
% VisualThing may be a RDF IRI of some OWL individual,
% a marker term (e.g., object(Iri)), or a data vis object (e.g., timeline(Identifier)).
% All existing markers are updated for the current timepoint if
% VisualThing is left unspecified.
% Properties is a list of properties passed to
% the respective submodules (i.e., marker or data visualization).
% If VisualThing is a list then each element is expected to be a term
% describing one visualization artifact.
%
show(Things) :-
  is_list(Things), !,
  show_next,
  forall( member(Thing, Things), (
    T =.. [show|Thing], call(T)
  )), !.

show(Thing) :-
  show(Thing,[]).

show(Thing, Properties) :-
  atom(Thing),
  rdf_resource(Thing),!,
  show_entity(Thing, Properties).

%show(DataVisTerm, Properties) :-
  %data_vis(DataVisTerm, Properties), !.

show_entity(Thing, Properties) :-
  object_state(Thing, State, Properties),
  mark_dirty_objects_cpp([State]).

%% show_next is det
show_next :-
  %marker_remove(trajectories).
  true.
