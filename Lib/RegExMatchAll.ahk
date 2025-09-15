class RegExMatchAll {
	__New(&haystack, needle) {
		this.Haystack := haystack
		this.Needle   := needle
	}

	__Enum(n) {
		this.Pos := 0
        return Next

        Next(&match) {
            if this.HasProp('Replacement') {
                this.Haystack := SubStr(this.Haystack, 1, this.Pos - 1)
                               . this.Replacement
                               . SubStr(this.Haystack, this.Pos + this.match.Len)

                this.DeleteProp('Replacement')
            }

            this.Pos   := RegExmatch(this.Haystack, this.Needle, &match, this.Pos + 1)
            this.match := match

            return this.Pos != 0
        }
	}
}