Class {
	#name : #GtWorldElement,
	#superclass : #BlElement,
	#instVars : [
		'spotterDropdown',
		'subSpaceDropdown',
		'tabs',
		'home'
	],
	#classVars : [
		'WorldSpotterSize'
	],
	#category : #'GToolkit-World-UI'
}

{ #category : #accessing }
GtWorldElement class >> worldSpotterSize [
	^ WorldSpotterSize ifNil: [ WorldSpotterSize := 800@600 ]
]

{ #category : #accessing }
GtWorldElement class >> worldSpotterSize: aPoint [
	WorldSpotterSize := aPoint
]

{ #category : #'instance creation' }
GtWorldElement >> home [
	^ home
]

{ #category : #initialization }
GtWorldElement >> initialize [
	super initialize.
	tabs := BrTabGroup new.
	tabs look: BrGlamorousSpaceTabGroupLook new.
	tabs actionbarStencil: [ self newActionbar ].
	home := GtHome new.
	tabs
		addTab:
			(BrTab new
				vExact: 36;
				look: BrGlamorousSpaceTabWithIconLook;
				icon: BrGlamorousVectorIcons gt;
				label: 'Home';
				stencil: [ home ]).
	self
		addShortcut:
			(BlShortcut new
				repeatable: false;
				combination: BlKeyCombination shiftReturn;
				action: [ spotterDropdown
						ifNotNil: [ spotterDropdown
								dispatchEvent:
									(BrDropdownShowWish new
										anchor: spotterDropdown;
										yourself) ] ]).
	self
		addShortcut:
			(BlShortcut new
				repeatable: false;
				combination: BlKeyCombination primaryT;
				action: [ subSpaceDropdown
						ifNotNil: [ subSpaceDropdown
								dispatchEvent:
									(BrDropdownShowWish new
										anchor: subSpaceDropdown;
										yourself) ] ]).
	self
		when: GtSpawnSpotter
		do: [ :e | 
			e consumed: true.
			spotterDropdown
				ifNotNil: [ spotterDropdown
						dispatchEvent:
							(BrDropdownShowWish new
								anchor: spotterDropdown;
								yourself) ] ].
	self addChild: tabs.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'private - instance creation' }
GtWorldElement >> newActionbar [
	| anActionbar |

	anActionbar := BrToolbar new.
	anActionbar look: BrGlamorousToolbarLook new.
	anActionbar addItem: self newSpotterButton.
	anActionbar addItem: self newSubSpaceButton.

	^ anActionbar
]

{ #category : #initialization }
GtWorldElement >> newSpotterButton [
	| look |
	self 
		assert: [ spotterDropdown isNil ]
		description: [ 'Spotter dropdown is already created!' ].
	spotterDropdown := BrButton new
		look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook
				+ (look := BrGlamorousWithDropdownLook stencil: [ | model |
							model := GtSpotter new.
							model announcer
								when: GtSpotterExitAnnouncement
								do: [ :e | look hide ].
							BlElement new 
								look: (BrGlamorousDropdownLook new
									handle: (BrButton new 
										look: BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook - BrGlamorousButtonExteriorLook;
										icon: BrGlamorousVectorIcons search);
									content: (GtSpotterElement new
										spotterModel: model;
										size: self class worldSpotterSize;
										when: GtSpotterResizedEvent do: [ :e | self class worldSpotterSize: e target size ]));
								background: BrGlamorousColors secondaryHeaderBackgroundColor ]);
		icon: BrGlamorousVectorIcons search;
		label: 'Search'.
	^ spotterDropdown
]

{ #category : #initialization }
GtWorldElement >> newSubSpaceButton [
	self
		assert: [ subSpaceDropdown isNil ]
		description: [ 'Sub-space dropdown is already created!' ].
	subSpaceDropdown := BrButton new
		look:
			BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons hamburger;
								label: 'Menu';
								yourself ]
						content: [ GtToolsMenu new
								constraintsDo: [ :c | 
									c vertical fitContent.
									c horizontal exact: 420 ];
								yourself ]);
		icon: BrGlamorousIcons hamburger;
		label: 'Menu';
		yourself.
	^ subSpaceDropdown
]

{ #category : #'private - instance creation' }
GtWorldElement >> newTabButtonLook [
	^ BrGlamorousButtonIconLook + BrGlamorousWithLabelTooltipLook + BrLayoutResizerLook inherit + BrLayoutAlignmentLook forHorizontalLinearLayout + (BrInteractiveCommonLook new
			default: [ :aWidget |
				aWidget geometry: BlCircle new.
				aWidget layout: BlLinearLayout horizontal alignCenter.
				aWidget background: (Color transparent) ];
			hovered: [ :aWidget | aWidget background: (Color gray alpha: 0.2) ];
			pressed: [ :aWidget | aWidget background: (Color gray alpha: 0.4) ])
]

{ #category : #initialization }
GtWorldElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.

	SystemAnnouncer uniqueInstance weak
		when: (ClassAnnouncement where: [ :ann | ann classAffected = GtHome ])
		send: #update:
		to: self home. 

	SystemAnnouncer uniqueInstance weak
		when: (MethodAnnouncement where: [ :ann | ann classAffected = GtHome ])
		send: #update:
		to: self home. 
]

{ #category : #initialization }
GtWorldElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	SystemAnnouncer uniqueInstance unsubscribe: self home
]

{ #category : #'api - opening' }
GtWorldElement >> showSpace: aSpace [
	| aTab |

	aTab := nil.
	aTab := (BrTab new
		vExact: 36;
		look: BrGlamorousSpaceTabWithLabelLook new;
		select;
		label: aSpace title;
		stencil: [
			aSpace root hasParent
				ifTrue: [ aSpace root removeFromParent ]
				ifFalse: [ aSpace root dispatchRemovedFromSceneGraph ].
			aSpace root
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical matchParent ] ];
		actionbarStencil: [
			BrToolbar new
				look: (BrGlamorousToolbarLook new spacing: 0);
				margin: (BlInsets left: 6);
				addItems: {
					BrButton new
						icon: BrGlamorousIcons maximize;
						exact: 16@16;
						opacity: 0.5;
						look: self newTabButtonLook;
						label: 'Open in a new window';
						action: [
							tabs removeTab: aTab.
							aTab := nil.
							GtWorld openWithSpaces: { aSpace } ].
					BrButton new
						icon: BrGlamorousVectorIcons close;
						exact: 16@16;
						opacity: 0.5;
						look: self newTabButtonLook;
						label: 'Close';
						action: [
							tabs removeTab: aTab.
							aTab := nil. ] } ]).

	tabs addTab: aTab
]

{ #category : #'children accessing' }
GtWorldElement >> topMostParent [
	^ self
]
