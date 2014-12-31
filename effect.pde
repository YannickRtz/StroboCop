public abstract class Effect implements Cloneable {

  public Effect() {
    // Constructor
  }
  
  public Object clone(){  
    try{  
        return super.clone();  
    }catch(Exception e){ 
        return null; 
    }
  }

  abstract void run();
}
