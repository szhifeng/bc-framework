package cn.bc.device.listener;

import cn.bc.device.service.DeviceEventNewPublishService;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;


@RunWith(SpringJUnit4ClassRunner.class)
@Transactional
@ContextConfiguration("classpath:spring-test.xml")
public class DeviceEventPublishTest {
  DeviceEventNewPublishService deviceEventNewPublishService;

  @Autowired
  public void setDeviceEventNewPublishService(
    DeviceEventNewPublishService deviceEventNewPublishService) {
    this.deviceEventNewPublishService = deviceEventNewPublishService;
  }

  @Test
  public void test() {
    // create
    DeviceEventListener.ok = true;
    // run
    deviceEventNewPublishService.publishEvent();

    // assert
    Assert.assertTrue(DeviceEventListener.ok);
  }

}
