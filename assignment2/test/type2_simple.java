public class TestTokenizer {
	int something() {
		System.out.println("1");
		System.out.println("2");
		System.out.println("3");
	}
	
	int somethingElse() {
		System.out.println("2");
		System.out.println("2");
		System.out.println("3");
	}
	
	int notClone() {
		System.out.println("2");
		int a = 1;
		System.out.println("2");
		System.out.println("3");
	}
}