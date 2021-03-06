<cfscript>

	// Define custom tag attributes.
	param name="attributes.multi" type="boolean" default="false";
	param name="attributes.name" type="string";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	switch ( thistag.executionMode ) {
		case "end":

			slots = getParentSlots();

			if ( attributes.multi ) {

				arrayAppend( slots[ attributes.name ], thistag.generatedContent );

			} else {

				slots[ attributes.name ] = thistag.generatedContent;

			}

			// This tag doesn't generate output - it only manipulates variables.
			thistag.generatedContent = "";

		break;
	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I walk the custom tag list looking for the first ancestor that as a "slots"
	* property defined. Returns the slots property or throws an error if it can't be
	* found.
	*/
	public struct function getParentSlots() {

		var instanceCounts = {};

		for ( var tagName in variables.splitBaseTagList( getBaseTagList() ) ) {

			if ( ! structKeyExists( instanceCounts, tagName ) ) {

				instanceCounts[ tagName ] = 0;

			}

			var parentTag = getBaseTagData( tagName, ++instanceCounts[ tagName ] );

			if ( structKeyExists( parentTag, "slots" ) ) {

				return( parentTag.slots );

			}

		}

		throw(
			type = "NotSlotsFound",
			message = "No slots object could be found in a parent tag.",
			extendedInfo="Base tag list: #getBaseTagList()#"
		);

	}


	/**
	* I split the given base-tag list, returning the array of tag-names.
	* 
	* @value I am the list of tags-names being split.
	*/
	public array function splitBaseTagList( required string value )
		cachedWithin = "request"
		{

		var tagNames = listToArray( arguments.value ).filter(
			( tagName ) => {

				// Some ColdFusion custom tags appear to be implemented as pseudo-custom
				// tags that don't actually expose any state. As such, we have to omit
				// these internal tags from the list otherwise our getBaseTagData() calls
				// will blow-up.
				return( arguments.tagName.reFindNoCase( "^cf_" ) );

			}
		);

		return( tagNames );

	}

</cfscript>
