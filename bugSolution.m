The solution involves explicitly removing the observer using `removeObserver:` before the observed object is deallocated. This prevents the KVO system from attempting to send notifications to a deallocated object.

```objectivec
@interface MyObject : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation MyObject
- (void)dealloc {
    NSLog(@"MyObject deallocated");
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"KVO notification received");
}
@end

int main() {
    MyObject *obj = [[MyObject alloc] init];
    MyObserver *observer = [[MyObserver alloc] init];
    [obj addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];

    obj.name = "New Name";
    [obj removeObserver:observer forKeyPath:@"name"]; // Correctly removes observer

    obj = nil; // Deallocates obj

    return 0;
}
```
By adding the `removeObserver:` call, the observer is cleanly detached before the object's deallocation, preventing the crash.