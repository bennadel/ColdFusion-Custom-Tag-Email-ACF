<cfscript>

	// Define custom tag attributes.
	param name="attributes.class" type="string" default="";
	param name="attributes.entity" type="string";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	switch ( thistag.executionMode ) {
		case "end":

			parentTag = getBaseTagData( getParentTagName( getBaseTagList() ) );

			for ( entityName in splitEntityNames( attributes.entity ) ) {

				themeVariableName = "$$entity:theme:#entityName#";

				if ( len( attributes.class ) ) {

					for ( className in splitClassNames( attributes.class ) ) {

						classVariableName = "#themeVariableName#.#className#";

						prefixContent = structKeyExists( parentTag, classVariableName )
							? ( ";" & parentTag[ classVariableName ] )
							: ""
						;

						parentTag.variables[ classVariableName ] = ( prefixContent & thistag.generatedContent );

					}

				} else {

					prefixContent = structKeyExists( parentTag, themeVariableName )
						? ( ";" & parentTag[ themeVariableName ] )
						: ""
					;

					parentTag.variables[ themeVariableName ] = ( prefixContent & thistag.generatedContent );

				}

			}

			// This tag doesn't generate output - it only manipulates variables.
			thistag.generatedContent = "";

		break;
	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the parent custom tag name from the given custom tag list.
	* 
	* @tagList I am the list of ColdFusion custom tag ancestors being parsed.
	*/
	public string function getParentTagName( required string tagList )
		cachedWithin = "request"
		{

		var tagNames = listToArray( arguments.tagList );
		var tagNameCount = arrayLen( tagNames );

		// The 1st tag is the current tag. We have to go above it.
		for ( var i = 2 ; i <= tagNameCount ; i++ ) {

			var tagName = tagNames[ i ];

			// Some ColdFusion custom tags appear to be implemented as pseudo-custom
			// tags that don't actually expose any state. As such, we have to omit
			// these internal tags from the list otherwise our getBaseTagData() calls
			// will blow-up.
			if ( reFindNoCase( "^cf_", tagName ) ) {

				return( tagName );

			}

		}

	}


	/**
	* I take the given class value (which is a delimited list of classes) and splits it
	* up and returns the array of class name tokens.
	* 
	* @value I am the class value being split.
	*/
	public array function splitClassNames( required string value )
		cachedWithin = "request"
		{

		return( reMatch( "\S+", arguments.value ) );

	}


	/**
	* I take the given entity value (which is a delimited list of entity names) and
	* splits it up and returns the array of entity name tokens.
	* 
	* @value I am the entity value being split.
	*/
	public array function splitEntityNames( required string value )
		cachedWithin = "request"
		{

		return( listToArray( arguments.value, ", " ) );

	}

</cfscript>
