class StringSet {
    StringList data;
    public String name;

    public StringSet(String name) {
        this.name = name;
        this.data = new StringList();
    }

    public void add(String s) {
        if (!this.data.hasValue(s)) this.data.append(s);
    }

    public void add(String[] l) {
        for (String s : l) this.add(trim(s));
    }

    public int length() {
        return this.data.size();
    }

    public String toString() {
        String out = "StringSet{\n";
        for (String s : this.data) out += "\t"+s+" "+s.length()+"\n";
        return out+"}\n";
    }

    public String[] toArray() {
        this.data.sort();
        return this.data.array();
    }
}
