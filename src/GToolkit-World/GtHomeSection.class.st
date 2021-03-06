Class {
	#name : #GtHomeSection,
	#superclass : #BrStencil,
	#instVars : [
		'priority'
	],
	#category : #'GToolkit-World-Sections'
}

{ #category : #testing }
GtHomeSection class >> isAbstract [ 
	^ self name = #GtHomeSection 
]

{ #category : #'instance creation' }
GtHomeSection >> newCard [
	^ self newCardWithoutIcon
		addLook: BrIconLook new;
		yourself
]

{ #category : #'instance creation' }
GtHomeSection >> newCardWithTitle: aTitle description: aDescription action: aBlock [ 
	| cardElement |	
	cardElement := self newCardWithoutIcon
		title: aTitle;
		description: ((aTitle asRopedText fontSize: 16) 
			append: ((String cr, String cr) asRopedText); 
			append: (aDescription asRopedText "foreground: Color gray; "fontSize: 14)).
	cardElement action: aBlock.
		
	^ cardElement
]

{ #category : #'instance creation' }
GtHomeSection >> newCardWithTitle: aTitle description: aDescription picture: anElementOrStencil action: aBlock [ 	
	^ self newCard
		title: aTitle;
		description: ((aTitle asRopedText fontSize: 18) 
			append: ((String cr, String cr) asRopedText); 
			append: (aDescription asRopedText "foreground: Color gray; "fontSize: 14));
		picture: (BlElement new 
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical matchParent ];
			layout: BlLinearLayout new;
			addChild: (anElementOrStencil asElement background: Color white; size: 300@300; asScalableElement);
			margin: (BlInsets all: 10);
			background: Color white;
			geometry: (BlRectangle cornerRadius: 4);
			look:" BrGlamorousButtonExteriorLook new + "BrShadowLook new;
"			border: (BlBorder paint: BrGlamorousColors defaultButtonBorderColor); "
			preventMeAndChildrenMouseEvents);
		action: aBlock
]

{ #category : #'instance creation' }
GtHomeSection >> newCardWithoutIcon [
	^ BrCard new
		look: "(BrShadowLook new) +"
			(BrDescriptionLook new readonly glamorousRegularFont descriptionDo: [:e | e padding: (BlInsets all: 10)]) +
			(BrGlamorousButtonExteriorLook new backgroundPaint: BrGlamorousColors secondaryHeaderBackgroundColor);
		layout: (BlLinearLayout horizontal alignCenter cellSpacing: 0);
		geometry: (BlRectangle cornerRadius: 4);
		constraintsDo: [ :c |
			c horizontal exact: 250.
			c vertical exact: 100 ];
		margin: (BlInsets top: self spaceGap left: self spaceGap * 2 bottom: self spaceGap right: self spaceGap * 2)
]

{ #category : #'instance creation' }
GtHomeSection >> newCardsContainer [
	^ BlElement new
		layout: BlFlowLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 0)
]

{ #category : #'instance creation' }
GtHomeSection >> newDocCardForClass: aClass [
	^ self
		newHeaderCardWithTitle: 'Doc'
		description: aClass name
		size: 150 @ 200
		content:
			(((GtDocument new text: aClass comment) gtTextFor: GtPhlowView empty)
				asElementDo: [ :e | 
					e
						exact: 300 @ 400;
						asScalableElement ])
		action: [ :card | 
			self
				showSpaceWithTitle: aClass name
				with: (GtInspector withToolOn: (GtDocument forClass: aClass))
				from: card ]
]

{ #category : #'instance creation' }
GtHomeSection >> newDocCardForFile: aReference [
	^ self
		newHeaderCardWithTitle: 'Doc'
		description: aReference fullName
		size: 150 @ 200
		content:
			(((GtDocument new text: aReference fileReference contents)
				gtTextFor: GtPhlowView empty)
				asElementDo: [ :e | 
					e
						exact: 300 @ 400;
						asScalableElement ])
		action: [ :card | 
			self
				showSpaceWithTitle: aReference fileReference basename
				with:
					(GtInspector
						withToolOn: (GtDocument forFile: aReference fileReference))
				from: card ]
]

{ #category : #'instance creation' }
GtHomeSection >> newHeaderCardWithTitle: aTitle description: aDescription size: aPoint content: anElement action: aBlock [
	| container headerContainer |

	container := BrButton new
		size: aPoint;
		layout: BlLinearLayout vertical;
		look: (BrGlamorousButtonExteriorLook new + BrGlamorousWithLabelTooltipLook new);
		label: aDescription;
		padding: (BlInsets all: 1);
		margin: (BlInsets top: self spaceGap left: 2 * self spaceGap bottom: self spaceGap right: 2 * self spaceGap);
		geometry: (BlRectangle cornerRadius: 4);
		action: aBlock.

	headerContainer := BlElement new
		constraintsDo: [:c | c horizontal matchParent. c vertical fitContent ];
		layout: BlLinearLayout vertical;
		background: BrGlamorousColors defaultButtonBorderColor;
		addChild: (BrLabel new look: (BrGlamorousLabelLook new fontSize: 10);
		text: aTitle).
	
	^ container
		addChild: headerContainer preventMeAndChildrenMouseEvents; 
		addChild: (anElement preventMeAndChildrenMouseEvents).
]

{ #category : #'instance creation' }
GtHomeSection >> newPlaygroundCardForPlaybook: aPlaybook title: aTitle description: aDescription [
	^ self
		newHeaderCardWithTitle: 'Playground: ' , aTitle
		description: aDescription
		size: 200 @ 200
		content:
			(aPlaybook asElement
				size: 400 @ 400;
				asScalableElement)
		action: [ :card | 
			self
				showSpaceWithTitle: aTitle
				with: (GtInspector withToolOn: aPlaybook)
				from: card ]
]

{ #category : #'instance creation' }
GtHomeSection >> newSectionButton [

	^ BrButton new
		padding: self newSectionTitlePaddingInsets
]

{ #category : #'instance creation' }
GtHomeSection >> newSectionButtonWithIcon: anIcon [

	^ self newSectionButton 
		look: BrGlamorousButtonWithIconLook;
		icon: anIcon asElement
]

{ #category : #'instance creation' }
GtHomeSection >> newSectionContainer [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'instance creation' }
GtHomeSection >> newSectionTitle: aString [
	^ BrLabel new
		look:
			(BrGlamorousLabelLook new
				foreground: Color gray;
				fontSize: 14);
		padding: self newSectionTitlePaddingInsets;
		text: aString
]

{ #category : #'instance creation' }
GtHomeSection >> newSectionTitleContainer [
	^ BrHorizontalPane new
		vFitContent;
		hMatchParent.
]

{ #category : #'instance creation' }
GtHomeSection >> newSectionTitlePaddingInsets [
	^ BlInsets left: self sectionPaddingLeftInsets
]

{ #category : #'instance creation' }
GtHomeSection >> newShowCardWithTitle: aString slideshow: aSlideShowBlock description: aDescription [
	^ self
		newHeaderCardWithTitle: 'Slideshow'
		description: aDescription
		size: 200 @ 150
		content:
			(aSlideShowBlock value slides first create
				constraintsDo: [ :c | 
					c horizontal exact: 800.
					c vertical exact: 600 ];
				padding: (BlInsets all: 10)) asScalableElement
		action: [ :card | 
			self
				showSpaceWithTitle: aString
				with: aSlideShowBlock value makeArrowsVisible
				from: card ]
]

{ #category : #'instance creation' }
GtHomeSection >> newToolCardWithTitle: aString icon: anElement action: aBlock description: aDescriptionString [
	| iconElement labelElement |
	iconElement := anElement margin: (BlInsets bottom: 5).
	labelElement := BrLabel new 
	    text: aString;
	    look: (BrGlamorousLabelLook new fontSize: 14).
	^ BrButton new
		constraintsDo:[ :c | 
	        c horizontal exact: 120.
	        c vertical exact: 120 ];
		margin: (BlInsets top: 10 left: 20 bottom: 10 right: 20);
		action: aBlock;
		padding: (BlInsets all: 10);
		label: aDescriptionString;
		look: (BrGlamorousButtonExteriorLook new + BrGlamorousWithLabelTooltipLook new);
		geometry: (BlRectangle cornerRadius: 4);
		layout: BlLinearLayout vertical alignCenter;
		addChild: iconElement;
		addChild: labelElement.
]

{ #category : #'instance creation' }
GtHomeSection >> newUrlCardWithTitle: aTitle description: aDescription url: aUrl [
	^ self
		newHeaderCardWithTitle: 'www'
		description: aDescription
		size: 200 @ 80
		content:
			(BlElement new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				layout: BlLinearLayout vertical alignCenter;
				addChild:
					(BrLabel new
						text: aTitle;
						look: BrGlamorousLabelLook);
				addChild:
					(BrLabel new
						text: aDescription;
						look:
							(BrGlamorousLabelLook new
								fontSize: 10;
								foreground: Color gray)))
		action: [ :card | WebBrowser openOn: aUrl ]
]

{ #category : #accessing }
GtHomeSection >> priority [
	^ priority
]

{ #category : #accessing }
GtHomeSection >> priority: aNumber [
	priority := aNumber
]

{ #category : #accessing }
GtHomeSection >> sectionPaddingLeftInsets [
	^ self spaceGap * 2
]

{ #category : #'instance creation' }
GtHomeSection >> showSpaceWithTitle: aString with: anElement from: anotherElement [
	| aSpace |
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 1200@600.
	aSpace addChild: anElement asElement.
	aSpace withHalos.
	anotherElement showSpace: aSpace
]

{ #category : #accessing }
GtHomeSection >> spaceGap [
	^ 10
]
