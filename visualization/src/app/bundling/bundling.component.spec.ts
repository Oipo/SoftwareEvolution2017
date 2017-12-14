import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BundlingComponent } from './bundling.component';

describe('BundlingComponent', () => {
  let component: BundlingComponent;
  let fixture: ComponentFixture<BundlingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BundlingComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BundlingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
