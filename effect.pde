public abstract class Effect implements Cloneable {

  public Effect() {
    // Constructor
  }
  
  public Effect clone(){  
    try{  
        return (Effect)super.clone();  
    }catch(Exception e){ 
        return null; 
    }
  }

  abstract void run();
}
