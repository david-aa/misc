class out {
    public static void main(String[] args) {
        String[] input = {"This", "is", "an", "array"};
        int max = 4;
        for (int x=0; x<=max; x++) {
            System.out.printf("Index: %d // Value: %s\n", x, input[x]);
        }
        System.out.println("Goodbye, I'm Java");
    }
}